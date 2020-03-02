## ZSH Aliases

# Replacements
alias vim="nvim"	# neovim
alias rm='trash'	# deletes to trash
alias cp='gcp'		# Gcp CoPier (https://code.lm7.fr/mcy/gcp)
alias ls='colorls --gs' # Colorls

# Config Aliases
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias vimrc="vim ~/.vimrc"
alias swaycfg="vim ~/.config/sway"

# Common Helpers 
alias ll="ls -l"
alias la="ls -al"

# Dotdrop Dotfiles
alias dotdrop="$DOTFILES/dotdrop.sh --cfg=$DOTFILES/config.yaml"

# IP Aliases
alias myip="ip addr | grep -m 1 -o '192.*.*.*' | cut -d '/' -f 1"
alias wanip="curl -s -X GET https://checkip.amazonaws.com"

# Copy PWD
alias cpwd='pwd | wl-copy'

# ZSH Time
alias zshtime='for i in $(seq 1 10); do /usr/bin/time -f "| Real: %es | User: %Us | Sys: %Ss |" zsh -i -c exit; done'

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
