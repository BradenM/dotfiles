#!/usr/bin/env python3

import i3ipc
from i3ipc import Event
from time import strftime, gmtime

"""Simple IPC debugging tool extended from example in docs."""

i3 = i3ipc.Connection()


def print_separator():
    print("-----")


def print_time():
    print(strftime(strftime("%Y-%m-%d %H:%M:%S", gmtime())))


def print_con_info(con):
    if con:
        print("Id: %s" % con.id)
        print("Name: %s" % con.name)
    else:
        print("(none)")


def on_window(i3, e):
    print_separator()
    print("Got window event:")
    print_time()
    print("Change: %s" % e.change)
    print_con_info(e.container)


def on_workspace(i3, e):
    print_separator()
    print("Got workspace event:")
    print_time()
    print("Change: %s" % e.change)
    print("Current:")
    print_con_info(e.current)
    print("Old:")
    print_con_info(e.old)


def on_binding(i3, e):
    print_separator()
    print("Got binding event:")
    print_time()
    print(f"Event: {e.change}")
    keybind = f"{'+'.join(e.binding.event_state_mask)}+{e.binding.symbol}"
    print(f'Binding: "{e.binding.command}" via "{keybind}"')


i3.on(Event.WINDOW, on_window)
i3.on(Event.WORKSPACE, on_workspace)
i3.on(Event.BINDING, on_binding)

i3.main()
