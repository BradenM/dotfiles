# Load Commands


# Pyenv
#_evalcache pyenv init -
#_evalcache pyenv virtualenv-init -

# Pipx Completions
_evalcache register-python-argcomplete pipx

# Ruby Env
#_evalcache rbenv init -


# Vault
#autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/vault vault

# Github Cli
#: replaced with zsh plugin
#_evalcache gh completion -s zsh

# Ntfy (notify) Completions
#_evalcache ntfy shell-integration

# Keep Cli
#_evalcache $(curl -SL https://raw.githubusercontent.com/OrkoHunter/keep/master/completions/keep.zsh)

# eksctl
#_evalcache eksctl completion zsh

# ntl
_evalcache ntl completion:generate --shell=zsh

# flux
_evalcache flux completion zsh

# Direnv
#eval "$(asdf exec direnv hook zsh)"


