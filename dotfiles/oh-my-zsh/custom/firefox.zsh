# Firefox
launch-firefox() {
  vk_pro env MOZ_DBUS_REMOTE=1 GDK_BACKEND=wayland MOZ_ENABLE_WAYLAND=1 /usr/lib/firefox/firefox "$@"
}

alias firefox='launch-firefox'
