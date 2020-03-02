
# qute-lastpass
config.bind('<CTRL-E>', 'spawn -u qute-lastpass -d "wofi --conf /home/bradenmars/.config/wofi/quteconfig -k /dev/null -m -d" -n -m', mode="normal")

# code hints
config.bind('<CTRL-c>', 'hint code userscript code_select.py', mode='hint')
