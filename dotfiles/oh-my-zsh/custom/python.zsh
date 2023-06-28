export PYTHONSTARTUP="${PYTHONSTARTUP:-$XDG_CONFIG_HOME/python/startup.py}"
export IPYTHONDIR="${IPYTHONDIR:-$XDG_CONFIG_HOME/ipython}"
export JUPYTER_CONFIG_DIR="${JUPYTER_CONFIG_DIR:-$XDG_CONFIG_HOME/ipython}"

# remove 'noglob pip' alias
unalias pip

# Virtualenv Wrapper
# export WORKON_HOME="$XDG_DATA_HOME/virtualenvwrapper"
# export PROJECT_HOME=$HOME/workspace
# check_prog "virtualenvwrapper_lazy.sh" && maybe_source "$(which virtualenvwrapper_lazy.sh)"
