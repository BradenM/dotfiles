#!/usr/bin/env python3

import asyncio
import time
from pathlib import Path

ROOT = Path("/tmp/install_fonts/fonts")
OUT = ROOT.parent / 'patched'
TTFS = [i for i in ROOT.rglob("*.ttf") if "Windows" not in i.name]
OTFS = [i for i in ROOT.rglob("*.otf") if "Windows" not in i.name]


async def run(cmd):
    proc = await asyncio.create_subprocess_shell(
        cmd,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE)

    stdout, stderr = await proc.communicate()

    if stdout:
        print(f'[stdout]\n{stdout.decode()}')
    if stderr:
        print(f'[stderr]\n{stderr.decode()}')


async def patch_font(path, to_path):
    cmd = f"fontforge -script ./font-patcher --complete --careful --progressbars --out {to_path} {path}"
    print("Patching: %s" % path.name)
    await run(cmd)
    print(f"Patched {path.name}")


async def bulk_patch(files):
    tasks = []
    for file in files:
        tasks.append(patch_font(file, OUT))
    await asyncio.gather(*tasks)

print("Starting...")
print("OUT:", OUT)
print("ROOT:", ROOT)
print("OTFS:", OTFS)
print("TTFS:", TTFS)
time.sleep(5)
asyncio.run(bulk_patch(files=OTFS))
