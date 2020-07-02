#!/usr/bin/env python3.8

import sys
import json
import tw
from datetime import timedelta

import dateutil.utils as dutil
import dateutil.tz as tz

from rich.console import Console
from rich.table import Table, Column
from rich import box

DATE_FORMAT = "%Y-%m-%d"
TIME_FORMAT = "%H:%M"

_, data = tw.parse_input(process=True)


def get_recent_entries():
    for entry in data:
        if dutil.within_delta(
            dutil.datetime.now(tz=tz.tzlocal()), entry["end"], timedelta(hours=24*4)
        ):
            time = f"{entry['interval'].hours}h {entry['interval'].minutes}m"
            desc = entry.get("annotation", "")
            logged = "✓" if "logged" in entry["tags"] else "✘"
            if len(desc) >= 20:
                desc = desc[:20] + "..."
            yield [
                entry["id"],
                entry["start"].strftime(DATE_FORMAT),
                entry["tags"][0],
                time,
                logged,
                desc,
            ]


con = Console()

table = Table(
    "ID",
    "Date",
    "Project",
    "Time",
    Column("Log", justify="center"),
    "Description",
    title="Recent Entries",
    expand=True,
    box=box.ROUNDED
)
for e in get_recent_entries():
    table.add_row(*[str(a) for a in e])

con.print(table)
