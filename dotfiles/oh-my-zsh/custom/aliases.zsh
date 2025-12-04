## ZSH Aliases

# Replacements
alias vim="nvim" # neovim
alias rm='trash' # deletes to trash
#unalias gcp
alias cat='bat' # Bat
#alias cp='gcp -v'	# Gcp CoPier (https://code.lm7.fr/mcy/gcp)
#alias ls='colorls --gs' # Colorls
alias ls='eza --icons --git'
alias sudo='sudo -v; sudo ' # Refresh timestamp timeout each time
alias p='pnpm'

# Config Aliases
alias zshcfg="$EDITOR ~ZSH_CUSTOM"
alias zshrc="$EDITOR ~/.zshrc"
alias ohmyzsh="$EDITOR ~/.oh-my-zsh"
alias vimrc="$EDITOR ~/.vimrc"
alias swaycfg="$EDITOR ~/.config/sway"

# Colored HowDoI
alias howdoi='howdoi -c -e google'
alias h='function hdi(){ howdoi $* -c -n 5; }; hdi'

# Common Helpers
alias l='ls'
alias ll="ls -l"
alias la="ls -al"
alias c='clear'
takeown() {
  sudo -E chown -R "${USER}:${USER}" "$@"
}

# Dotdrop Dotfiles
alias dotdrop="$DOTFILES/dotdrop.sh --cfg=$DOTFILES/config.yaml"

# IP Aliases
alias myip="ip addr | grep -m 1 -o '192.*.*.*' | cut -d '/' -f 1"
alias wanip="curl -s -X GET https://checkip.amazonaws.com"

# Copy/Paste PWD
alias cpwd='pwd | wl-copy -n'
alias ppwd='cd $(wl-paste)'

# Copy/Paste
alias wcp='wl-copy -n'
alias wpp='wl-paste -n'
alias wpick="clipman pick --print0 --tool=CUSTOM --tool-args=\"fzf --prompt 'pick > ' --bind 'tab:up' --cycle --read0\""

alias w3mimgdisplay='/usr/lib/w3m/w3mimgdisplay'

# Flutter (fix colors)
alias flutter='TERM=xterm-256color \flutter'

# Remove bad aliases
# unalias duf  # duf is an improved/modern version of du
unalias ps # a really bad alias for some pnpm command that came from pnpm zsh plugin

# autojump -> zoxide
alias j='z'

# Explain Shell Shortcut
eshell() {
  local url
  url="https://explainshell.com/explain?cmd=${1}"
  open_command "$url"
}

# ZSH Time
alias zshtime='for i in $(seq 1 10); do /usr/bin/time -f "| Real: %es | User: %Us | Sys: %Ss |" zsh -i -c exit; done'

# Time a command
timeit() {
  /usr/bin/time -f "| Real: %es | User: %Us | Sys: %Ss |" $@
}

# Date Helpers
conv_times() {
  intime=("$(date +'%I:%M')" "${@}")
  convs=()
  for t in "${intime[@]}"; do
    val=$(date -d"$t" +"%H:%M")
    convs+="$t $val\n"
  done
  cols=('12hr' '24hr')
  printf "12hr 24hr\n${convs[*]}" | column -t -s' '
}

# Start SSH Agent
alias ssh='TERM=xterm-256color command ssh'
alias ssha='eval $(ssh-agent)'

# LS with numerical permission values
alias cls='stat -c "%a %n" *'

# Disk Analyzer
alias disk-analyze="su -c baobab"

# Nextcloud - Find Conflicted Files
alias nc-conflict="fd -HIg '*conflicted*'"

# LastPass - Fuzzy Search
search_lastpass() {
  lpass show --all $(lpass ls | fzf | awk '{print $(NF)}' | sed 's/\]//g')
}
alias lpfind="search_lastpass"

# System Info
alias sysinfo='inxi -Fxxxz'

# Direnv Allow
#direnv() { mise exec direnv@2.36.0 -- direnv "$@"; } # asdf shortcut
alias dallow='mise exec direnv -- direnv allow'
#: Wrap tmux (see: https://github.com/direnv/direnv/wiki/Tmux)
#alias tmux='direnv exec / tmux'

# System Errors
alias errors="journalctl -b -p err|less"

# Mise
alias m="mise"
alias x="mise exec --"
alias r="mise run --"
