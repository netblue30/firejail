# Firejail profile for blink-common
# Description: Common profile for Blink-based applications
# This file is overwritten after every install/update
# Persistent local customizations
include blink-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

whitelist ${DOWNLOADS}
include whitelist-common.inc
#include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

# If your kernel allows the creation of user namespaces by unprivileged users
# (for example, if running `unshare -U echo enabled` prints "enabled"), you
# can add the next line to your blink-common.local.
#include blink-common-hardened.inc.profile

apparmor
caps.keep sys_admin,sys_chroot
netfilter
nodvd
nogroups
noinput
notv

disable-mnt
private-cache

dbus-system none
