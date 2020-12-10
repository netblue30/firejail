# Firejail profile for electron
# Description: Build cross platform desktop apps with web technologies
# This file is overwritten after every install/update
# Persistent local customizations
include electron.local

include disable-common.inc
include disable-passwdmgr.inc
include disable-programs.inc

whitelist ${DOWNLOADS}
include whitelist-common.inc

# Uncomment the next line (or add it to your chromium-common.local)
# if your kernel allows unprivileged userns clone.
#include chromium-common-hardened.inc

apparmor
caps.keep sys_admin,sys_chroot
netfilter
nodvd
nogroups
notv

dbus-user none
dbus-system none
