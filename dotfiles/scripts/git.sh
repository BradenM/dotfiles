#!/usr/bin/env bash

# git.sh
# Git Related Helper Functions


# Download Git Directory
git_dir(){
    local project="$1"
    local path="$2"
    local url="https://github.com/${project}/trunk/${path}"
    /usr/bin/svn export "$url" "$3"
}

# Git Ignore
function gi() { curl -sLw "\n" "https://www.gitignore.io/api/$@" ;}
