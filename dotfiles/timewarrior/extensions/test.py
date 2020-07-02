#!/usr/bin/env python
import sys

print("test")
print(sys.argv)
content = sys.stdin.readlines()

print(content)
print("gap:", content.index("\n"))
