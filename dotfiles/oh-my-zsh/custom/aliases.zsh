## ZSH Aliases

# Replacements
alias vim="nvim"	# neovim
alias rm='trash'	# deletes to trash
alias cp='gcp -v'	# Gcp CoPier (https://code.lm7.fr/mcy/gcp)
alias ls='colorls --gs' # Colorls

# Config Aliases
alias zshcfg="$EDITOR ~ZSH_CUSTOM"
alias zshrc="$EDITOR ~/.zshrc"
alias ohmyzsh="$EDITOR ~/.oh-my-zsh"
alias vimrc="$EDITOR ~/.vimrc"
alias swaycfg="$EDITOR ~/.config/sway"

# Colored HowDoI
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
alias dallow='asdf exec direnv allow'
