# Firejail profile for electron
# Description: Build cross platform desktop apps with web technologies
# This file is overwritten after every install/update
# Persistent local customizations
include electron.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist ${DOWNLOADS}
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

# Uncomment the next line (or add it to your chromium-common.local)
# if your kernel allows unprivileged userns clone.
#include chromium-common-hardened.profile

apparmor
caps.keep sys_admin,sys_chroot
netfilter
nodvd
nogroups
notv
nou2f
novideo
shell none

disable-mnt
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none
