# ZSH Aliases

# Copy PWD
alias cpwd='pwd | wl-copy'

# ZSH Time
alias zshtime='for i in $(seq 1 10); do /usr/bin/time -f "| Real: %es | User: %Us | Sys: %Ss |" zsh -i -c exit; done'

# Start SSH Agent
alias ssha='eval $(ssh-agent)'
