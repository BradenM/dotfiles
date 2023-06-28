# Load Commands

# Pipx Completions
_evalcache register-python-argcomplete pipx

# Vault
complete -o nospace -C /usr/bin/vault vault

# ntl
_evalcache ntl completion:generate --shell=zsh

# flux
_evalcache flux completion zsh

# atuin
_evalcache atuin init zsh
