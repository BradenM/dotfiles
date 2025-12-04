# SSH Utilities 

_ssh_with_control_persist() {
  local control_path="$HOME/.ssh/sockets/%r@%h-%p"
  mkdir -p $(dirname $control_path)

  local ssh_options=(
    "ControlPersist=60"
    "ControlMaster=auto"
    "ControlPath=$control_path"
    "ServerAliveInterval=60"
    "ServerAliveCountMax=120"
  )

  # Use the array with the -o flag for each element
  local ssh_command=(ssh)
  for option in "${ssh_options[@]}"; do
    ssh_command+=(-o "$option")
  done

  # Append the rest of the arguments
  ssh_command+=("$@")

  # Execute the SSH command
  env TERM=xterm-256color "${ssh_command[@]}"
}

alias ssh-persist=_ssh_with_control_persist
