#!/usr/bin/env python3.8

import subprocess as sp
import json

data = sp.run(['task', '+in','+PENDING', 'count'], stdout=sp.PIPE, text=True).stdout.strip()

out = json.dumps(dict(text=f"{data}   "))
print(out)
