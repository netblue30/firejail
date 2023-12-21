# Firejail profile for minecraft-launcher
# Description: Official Minecraft launcher from Mojang
# This file is overwritten after every install/update
# Persistent local customizations
include minecraft-launcher.local
# Persistent global definitions
include globals.local

# Some distros put the executable in /opt/minecraft-launcher.
# Run 'firejail /opt/minecraft-launcher/minecraft-launcher' to start it.

ignore noexec ${HOME}

noblacklist ${HOME}/.minecraft

include allow-java.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.minecraft
whitelist ${HOME}/.minecraft
# Needs keyring access in order to save logins
whitelist ${RUNUSER}/keyring
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
tracelog

disable-mnt
private-bin java,java-config,minecraft-launcher
private-cache
private-dev
# If multiplayer or realms break, add 'private-etc <your-own-java-folder-from-/etc>'
# or 'ignore private-etc' to your minecraft-launcher.local.
private-etc @tls-ca,@x11,host.conf,java*,mime.types,services,timezone
private-opt minecraft-launcher
private-tmp

dbus-user filter
dbus-user.talk org.freedesktop.secrets
dbus-user.talk org.gnome.keyring.*
dbus-user.talk org.gnome.seahorse.*
dbus-system none

restrict-namespaces
