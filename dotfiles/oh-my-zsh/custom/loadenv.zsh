# Load Commands

# Pyenv
_evalcache pyenv init -
_evalcache pyenv virtualenv-init -

# Pipx Completions
_evalcache register-python-argcomplete pipx

# Direnv
#_evalcache direnv hook zsh
_evalcache asdf exec direnv hook zsh

# Ruby Env
_evalcache rbenv init -


# Vault
#autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/vault vault

# Github Cli
_evalcache gh completion -s zsh

# Ntfy (notify) Completions
#_evalcache ntfy shell-integration

