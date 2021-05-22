## ZSH Aliases

# Replacements
alias vim="nvim"	# neovim
alias rm='trash'	# deletes to trash
unalias gcp
alias cat='bat'  # Bat
alias cp='gcp -v'	# Gcp CoPier (https://code.lm7.fr/mcy/gcp)
alias ls='colorls --gs' # Colorls
alias sudo='sudo -v; sudo ' # Refresh timestamp timeout each time
alias p='pnpm'

# Config Aliases
alias zshcfg="$EDITOR ~ZSH_CUSTOM"
alias zshrc="$EDITOR ~/.zshrc"
alias ohmyzsh="$EDITOR ~/.oh-my-zsh"
alias vimrc="$EDITOR ~/.vimrc"
alias swaycfg="$EDITOR ~/.config/sway"

# Colored HowDoI
alias howdoi='howdoi -c -e duckduckgo'
alias h='function hdi(){ howdoi $* -c -n 5; }; hdi'

# Common Helpers 
alias ll="ls -l"
alias la="ls -al"

# Dotdrop Dotfiles
alias dotdrop="$DOTFILES/dotdrop.sh --cfg=$DOTFILES/config.yaml"

# IP Aliases
alias myip="ip addr | grep -m 1 -o '192.*.*.*' | cut -d '/' -f 1"
alias wanip="curl -s -X GET https://checkip.amazonaws.com"

# Copy/Paste PWD
alias cpwd='pwd | wl-copy'
alias ppwd='cd $(wl-paste)'

# ZSH Time
alias zshtime='for i in $(seq 1 10); do /usr/bin/time -f "| Real: %es | User: %Us | Sys: %Ss |" zsh -i -c exit; done'

# Time a command
timeit() {
    /usr/bin/time -f "| Real: %es | User: %Us | Sys: %Ss |" $@
}

# Date Helpers
conv_times () {
    intime=("$(date +'%I:%M')" "${@}" )
    convs=()
    for t in "${intime[@]}"; do
        val=$(date -d"$t" +"%H:%M" )
        convs+="$t $val\n"
    done
    cols=('12hr' '24hr')
    printf "12hr 24hr\n${convs[*]}" | column -t -s' '
}

# Start SSH Agent
alias ssha='eval $(ssh-agent)'

# LS with numerical permission values
alias cls='stat -c "%a %n" *'

# Disk Analyzer
alias disk-analyze="su -c baobab"

# Nextcloud - Find Conflicted Files
alias nc-conflict="fd -HIg '*conflicted*'"

# LastPass - Fuzzy Search
search_lastpass() {
	lpass show --all $(lpass ls  | fzf | awk '{print $(NF)}' | sed 's/\]//g')
}
alias lpfind="search_lastpass"

# System Info
alias sysinfo='inxi -Fxxxz'

# Task Warrior
alias in='task add +in'

#: GTD Tickle
tickle () {
    deadline=$1
    shift
    in +tickle wait:$deadline $@
}
alias tick=tickle

alias think='tickle +1d'

# Direnv Allow
direnv() { asdf exec direnv "$@"; } # asdf shortcut
alias dallow='asdf exec direnv allow'
#: Wrap tmux (see: https://github.com/direnv/direnv/wiki/Tmux)
alias tmux='direnv exec / tmux'

# System Errors
alias errors="journalctl -b -p err|less"

# Git
alias g="git"

# Minikube
alias mk='minikube'

# Kubectx
alias kctx='kubectx'

# Kubernetes
alias kevents="k get events --sort-by=.metadata.creationTimestamp"
# Get EKS token
ekstoken () {
  cluster=$(kubectx -c | awk -F '/' '{print $2}')
  echo "Retrieving token for: ${cluster}"
  token=$(aws eks get-token --cluster "$cluster" | jq -r '.status.token')
  echo "$token" | wl-copy
  echo "Copied token to clipboard:"
  echo "$token"
}
# Get Secret
ksecret () {
  k get secret -n "${3:-default}" "$1" --output="jsonpath={.data.${2}}" | base64 --decode
}
# Update Secret
kupsecret() {
  secretName="$1"
  secretKey="$2"
  secretValue="$3"
  kubectl get secret -n "${4:-default}" "$secretName" -o json | jq --arg newVal "$(echo -n ${secretValue} | base64 -w 0)" $(printf '.data["%s"]=$newVal' "$secretKey") | kubectl apply -f -
}
# KubeSpy
alias kspy='kubespy'

# Android (ADB)
adb_all () {
  # execute adb command on all connected devices.
  adb devices | tail -n +2 | cut -sf -1 | xargs -I X adb -s X $@
}
alias adba=adb_all
alias adba-clear="adb_all shell pm clear ${ANDROID_PKG:-$1}"
alias adba-start="adba shell am start ${ANDROID_PKG:-$1}/.MainActivity"
alias adba-rm="adba shell uninstall ${ANDROID_PKG:-$1}"
alias adba-ls="adb_all shell list packages -3"

# ADB Event Replay
adb-rec() {
  record_path="${@: -1}"
  adb_args="${@: 1:-1}"
  echo "Recording events to: $record_path"
  echo $adb_args
  adb $adb_args shell getevent | grep --line-buffered ^/ | tee "$record_path"
}

adb-replay() {
  record_path="${@: -1}"
  adb_args="${@: 1:-1}"
  awk '{printf "%s %d %d %d\n", substr($1, 1, length($1) -1), strtonum("0x"$2), strtonum("0x"$3), strtonum("0x"$4)}' $record_path | xargs -l adb $adb_args shell sendevent
}
