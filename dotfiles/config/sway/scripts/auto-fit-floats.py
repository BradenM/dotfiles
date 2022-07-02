#!/usr/bin/env /home/bradenmars/.pyenv/versions/3.10.1/bin/python

import asyncio
from operator import attrgetter
from weakref import WeakSet, getweakrefs, getweakrefcount
from pathlib import Path
from i3ipc.aio import Connection, Con
from i3ipc.events import Event, WindowEvent
from rich import inspect
from toolz.curried import *
from contextlib import asynccontextmanager, AsyncExitStack
from rich.console import Console
import logging
from rich.logging import RichHandler

console = Console()

FORMAT = "%(message)s"
logging.basicConfig(
    level="DEBUG", format=FORMAT, datefmt="[%X]",
    handlers=[RichHandler(markup=True, rich_tracebacks=True, console=console)]
)

FITTED_WINDOWS = set()

logger = logging.getLogger("auto-floats")


async def do_fit():
    sh_path = Path.home() / ".scripts" / "bin" / "sway-fit-floats"
    assert sh_path.exists()
    logger.debug(f'exec: {sh_path}')
    proc = await asyncio.create_subprocess_exec(
        sh_path,
        '--verbose',
        stderr=asyncio.subprocess.PIPE,
        stdout=asyncio.subprocess.PIPE,
    )
    stdout, stderr = await proc.communicate()
    logger.info(f'[sway-fit-floats exited with {proc.returncode}]')
    if stdout:
        logger.debug(f'[stdout]\n{stdout.decode()}')
    if stderr:
        logger.debug(f'[stderr]\n{stderr.decode()}')


@curry
async def con_do(c: Con, cmd: str):
    logger.info(f"[b]<{c.name}>[/b]: executing -> {cmd}")
    await c.command(cmd)


@asynccontextmanager
async def scratchpad_stash(con: Con):
    orig_workspace = "current"
    orig_rect = con.rect
    ws_rect = con.workspace().rect
    orel_x, orel_y = orig_rect.x - ws_rect.x, orig_rect.y - ws_rect.y
    if (orig_num := con.workspace().num) is not None:
        orig_workspace = f"number {orig_num}"
    crun = con_do(con)
    try:
        logger.info(f"stashing <{con.name}|[WS:{orig_workspace}]> in scratchpad.")
        await crun('focus')
        await crun('move window to scratchpad')
        # await con.command('focus; move window to scratchpad')
        yield con
    finally:
        commands = [
            f'move window to workspace {orig_workspace}', 'focus',
            f'move position {orel_x} {orel_y}'
        ]
        [await c for c in map(crun)(commands)]
        # await con.command()
        logger.info(f"popped <{con.name}|[WS:{orig_workspace}]> from scratchpad.")


async def fit_window(c: Connection, con: Con):
    tree = await c.get_tree()
    con = tree.find_by_id(con.id)
    current_win = tree.find_focused()

    con_names = map(attrgetter('name'))
    con_app_ids = map(attrgetter('app_id'))

    floats = [t for t in tree if t.type == 'floating_con']
    app_id_freqs = frequencies(con_app_ids(floats))
    targ_freq = app_id_freqs.get(con.app_id, 1)

    logger.info('float counts by app_id: %s', app_id_freqs)
    if targ_freq <= 1:
        logger.warn('skipping refit as their is only 1 window!')
        return

    target_wkspace = con.workspace()
    logger.info('floats: %s', list(con_names(floats)))

    # other_floats = list(remove(lambda w: w.workspace() == target_wkspace)(floats))
    other_floats = filter(lambda w: getattr(w.workspace(), 'id', None) != target_wkspace.id)(floats)
    other_floats: list[Con] = list(remove(lambda w: w.id == con.id, other_floats))

    logger.info('other floats: %s', list(con_names(other_floats)))

    # on_win = curry(lambda s,w: do(hj))

    do_focus = lambda w: w.command('focus')
    do_float = lambda w: w.command('floating true')
    do_unfloat = lambda w: w.command('floating false')

    wait_all = partial(asyncio.wait, return_when=asyncio.ALL_COMPLETED)

    async with AsyncExitStack() as stack:
        stashed = [await stack.enter_async_context(scratchpad_stash(sc)) for sc in other_floats]
        await do_focus(current_win)
        await do_fit()

    logger.info('restoring focus..')
    await do_focus(current_win)

    # unfloat_others = mapcat(
    #     lambda w: asyncio.create_task(juxt(do_focus, do_unfloat)(w))
    # )(other_floats.copy())
    # await wait_all(unfloat_others)
    # logger.info('others unfloated!')

    # await asyncio.wait_for(do_focus(con), 10)
    # await asyncio.sleep(3.0)
    # await asyncio.wait_for(do_fit(), 10)

    # logger.info('refloating:', other_floats)
    # float_others = mapcat(
    #     lambda w: asyncio.create_task(juxt(do_focus, do_float)(w))
    # )(other_floats)
    # await wait_all(float_others)
    # logger.info('others floated!')
    # await do_focus(current_win)
    #
    # def on_done(*args, **kwargs):
    #     logger.info('on done:', args, kwargs)
    #     logger.info('wins:', FITTED_WINDOWS)
    #     FITTED_WINDOWS.remove(con)


async def main():
    task_lock = asyncio.Lock()

    async def create_fit_task(c: Connection, con: Con):
        if task_lock.locked():
            logger.info('skipping due to active task...')
            return
        async with task_lock:
            console.rule(f"[bold bright_white]Auto Floating: {con.name}")
            await fit_window(c, con)
        logger.info('task complete.')

    def handle_window(c: Connection, e: WindowEvent):
        if e.container and e.container.type == "floating_con":
            # inspect(e)
            asyncio.create_task(create_fit_task(c, e.container))
            # sh_path = Path.home() / ".scripts" / "bin" / "sway-fit-floats"
            # asyncio.create_task(tsk, name="sway-fit-floats")
            # await asyncio.create_subprocess_exec()

    sway = await Connection(auto_reconnect=True).connect()
    sway.on(Event.WINDOW_FLOATING, handle_window)

    await sway.main()


asyncio.get_event_loop().run_until_complete(main())
