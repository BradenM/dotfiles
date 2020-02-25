# Load Commands

# Pyenv
_evalcache pyenv init -
_evalcache pyenv virtualenv-init -

# Pipx Completions
_evalcache register-python-argcomplete pipx

# Direnv
_evalcache direnv hook zsh

# Ruby Env
_evalcache rbenv init -
