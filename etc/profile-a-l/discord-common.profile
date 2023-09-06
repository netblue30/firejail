# Firejail profile for discord
# This file is overwritten after every install/update
# Persistent local customizations
include discord-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

# Disabled until someone reported positive feedback
ignore apparmor

ignore noexec ${HOME}
ignore novideo

whitelist ${HOME}/.config/BetterDiscord
whitelist ${HOME}/.local/share/betterdiscordctl

private-bin awk,bash,cut,echo,egrep,electron,electron[0-9],electron[0-9][0-9],fish,grep,head,sed,sh,tclsh,tr,which,xdg-mime,xdg-open,zsh
private-etc @tls-ca

# allow D-Bus notifications
dbus-user filter
dbus-user.talk org.freedesktop.Notifications
ignore dbus-user none

join-or-start discord

# Redirect
include electron-common.profile
