#!/hint/bash

# Git related items.

# Git
alias g="git"
alias lg="lazygit"
alias gmc="git-machete"

# Replaced with improved script.
alias git_dir='~/.scripts/git-dir-download'

# Git Ignore
function gi() {
  for ignore in "${@}"; do
    curl -sL https://www.gitignore.io/api/$ignore
  done
}
