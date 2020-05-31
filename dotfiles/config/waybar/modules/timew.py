#!/usr/bin/env python3

import dateutil.parser
import dateutil.tz
from dateutil.relativedelta import relativedelta
from datetime import datetime

import subprocess as sp
import json

icon=""

data = json.loads(sp.run(['timew', 'get', 'dom.active.json'], stdout=sp.PIPE).stdout)

start_dt = dateutil.parser.isoparse(data['start'])
now_dt = datetime.now(tz=dateutil.tz.UTC)
delta = relativedelta(now_dt, start_dt)

minutes = delta.minutes
if minutes < 10:
    minutes = f'0{minutes}'


duration = f"{delta.hours}:{minutes}"

annotation = data.get('annotation', None)
if annotation:
    annotation = f'# {annotation}'

result = f"{icon}  {data['tags'][0]} {annotation} - {duration}"

output = dict(text=result)
print(json.dumps(output))


