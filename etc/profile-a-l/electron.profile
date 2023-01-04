# Firejail profile for electron
# Description: Build cross platform desktop apps with web technologies
# This file is overwritten after every install/update
# Persistent local customizations
include electron.local

noblacklist ${HOME}/.config/Electron
noblacklist ${HOME}/.config/electron*-flag*.conf

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/Electron
whitelist ${HOME}/.config/electron*-flag*.conf
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

# Add the next line to your electron.local if your kernel allows unprivileged userns clone.
#include electron-hardened.inc.profile

apparmor
caps.keep sys_admin,sys_chroot
netfilter
nodvd
nogroups
noinput
notv
nou2f
novideo

disable-mnt
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none
