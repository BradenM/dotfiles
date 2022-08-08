## ZSH Aliases

# Replacements
alias vim="nvim"	# neovim
alias rm='trash'	# deletes to trash
#unalias gcp
alias cat='bat'  # Bat
#alias cp='gcp -v'	# Gcp CoPier (https://code.lm7.fr/mcy/gcp)
#alias ls='colorls --gs' # Colorls
alias ls='exa --icons --git'
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

# Remove bad aliases
unalias duf  # duf is an improved/modern version of du
unalias ps   # a really bad alias for some pnpm command that came from pnpm zsh plugin

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
alias tin='task add +in'

#: GTD Tickle
tickle () {
    deadline=$1
    shift
    task add +in +tickle wait:$deadline $@
}
alias tick=tickle

alias think='tickle +1d'

# Direnv Allow
direnv() { asdf exec direnv "$@"; } # asdf shortcut
alias dallow='asdf exec direnv allow'
#: Wrap tmux (see: https://github.com/direnv/direnv/wiki/Tmux)
#alias tmux='direnv exec / tmux'

# System Errors
alias errors="journalctl -b -p err|less"

# Git
alias g="git"
alias lg="lazygit"

# Docker / Compose
unalias dcrm
alias dcrm='docker compose run --rm'

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

# AWS Utils
auth-ecr() {
  if [[ $# -ge 2 ]]; then
    account_id="$1"
    ecr_repo="$2"
    region="${3:-us-east-1}"
    printf "Authenticating w/ ECS: (%s @ %s) [%s]" "${account_id}" "${ecr_repo}" "${region}"
    aws ecr get-login-password --region "$region" | docker login --username AWS --password-stdin "${account_id}.dkr.ecr.${region}.amazonaws.com/${ecr_repo}"
  else
    echo 1>&2 "Usage: auth-ecr [ACCOUNT_ID] [ECR_REPO] (REGION=us-east-1)"
  fi
}

# GTK List Themes
gtk-lsthemes() {
  find $(find ~/.themes /usr/share/themes/ -wholename "*/gtk-3.0" | sed -e "s/^\(.*\)\/gtk-3.0$/\1/") -wholename "*/gtk-2.0" | sed -e "s/.*\/\(.*\)\/gtk-2.0/\1"/
}

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

alias nvim=nvimvenv
unalias vim
alias vim=nvimvenv
