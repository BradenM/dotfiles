# Git related items.

# Git
alias g="git"
alias lg="lazygit"

# Download Git Directory
git_dir(){
    local project="$1"
    local path="$2"
    local url="https://github.com/${project}/trunk/${path}"
    echo "Downloading directory (${path} @ ${url}) ~> ${path}"
    /usr/bin/svn export "$url" "$3"
}

# Git Ignore
function gi() { curl -sLw "\n" "https://www.gitignore.io/api/$@" ;}
