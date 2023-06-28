#!/usr/bin/env /home/bradenmars/.pyenv/versions/3.10.1/bin/python


import sys
import dateutil.parser
import dateutil.tz
from dateutil.relativedelta import relativedelta
from datetime import datetime

import subprocess as sp
import json

# icon=""
icon=""
args = sys.argv[1:]

try:
    data = json.loads(sp.run(['timew', 'get', 'dom.active.json'], stdout=sp.PIPE, stderr=sp.PIPE).stdout)
except:
    print(json.dumps(dict(text="")))
    sys.exit(0)

start_dt = dateutil.parser.isoparse(data['start'])
now_dt = datetime.now(tz=dateutil.tz.UTC)
delta = relativedelta(now_dt, start_dt)

minutes = delta.minutes
if minutes < 10:
    minutes = f'0{minutes}'


duration = f"{delta.hours}:{minutes}"

annotation = data.get('annotation', None)
if annotation:
    annotation = f' # {annotation}'
    if len(annotation) >= 20:
        annotation = f"{annotation[:20]}..."

desc = data['tags'][1]
desc = f" # {desc}"
proj = ' '.join([t.capitalize() for t in data['tags'][2].split('.')])

if len(args) and args[0].strip() == "short":
    result = f"{icon}  {duration}"
else:
    result = f"{icon}  {proj}{annotation or desc} - {duration}"

output = dict(text=result)
print(json.dumps(output))


