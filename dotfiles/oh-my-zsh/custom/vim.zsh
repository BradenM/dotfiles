# Vim related shell items.

# ensure python nvim
function nvimvenv {
  if [[ -e "$VIRTUAL_ENV" && -f "$VIRTUAL_ENV/bin/activate" ]]; then
    source "$VIRTUAL_ENV/bin/activate"
    command nvim $@
    deactivate
  else
    command nvim $@
  fi
}

# alias nvim=nvimvenv
# unalias vim
# alias vim=nvimvenv
alias vim=nvim

