# GTK related items.

# GTK List Themes
gtk-lsthemes() {
  find $(find ~/.themes /usr/share/themes/ -wholename "*/gtk-3.0" | sed -e "s/^\(.*\)\/gtk-3.0$/\1/") -wholename "*/gtk-2.0" | sed -e "s/.*\/\(.*\)\/gtk-2.0/\1"/
}

refresh-gtk-app-icons() {
  local root=($(sudo find /usr/share/icons -name "*.cache" -exec dirname {} \;))
  local usr=($(find ~/.local -name "*.cache" -exec dirname {} \;))
  local paths=("${root[@]}" "${usr[@]}")
  for p in "${paths[@]}"; do
    local base=$(basename $p)
    printf "Clearing ${base} Icons...\n"
    sudo gtk-update-icon-cache -f -t $p/*
    gtk-update-icon-cache ~/.local/share/icons/hicolor/**/* -t -f
    update-mime-database ~/.local/share/mime
    update-desktop-database ~/.local/share/applications
    sudo update-mime-database /usr/share/mime
    sudo update-desktop-database /usr/share/applications
    xdg-desktop-menu forceupdate
    printf "\n"
  done
  printf "Done. Refresh your session now please.\n"
}
