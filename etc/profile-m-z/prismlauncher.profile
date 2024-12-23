# Firejail profile for PrismLauncher
# Description: An Open Source Minecraft launcher with the ability to manage multiple instances, accounts and mods.
# This file is overwritten after every install/update
# Persistent local customizations
include prismlauncher.local
# Persistent global definitions
include globals.local

# Allow java (blacklisted by disable-devel.inc)
include allow-java.inc

include disable-common.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-shell.inc

whitelist ${HOME}/.local/share/PrismLauncher
whitelist ${HOME}/Downloads
include whitelist-common.inc

apparmor
caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noprinters
noroot
notpm
notv
nou2f
protocol unix,inet,inet6
seccomp
seccomp.block-secondary

disable-mnt
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
