# Firejail profile for chromium-common
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/chromium-common.local
# Persistent global definitions
# already included by caller profile
#include /etc/firejail/globals.local

noblacklist ${HOME}/.pki

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.pki
whitelist ${DOWNLOADS}
whitelist ${HOME}/.pki
include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

apparmor
caps.keep sys_chroot,sys_admin
netfilter
# Breaks Gnome connector - disable if you use that
nodbus
nodvd
nogroups
notv
shell none

disable-mnt
private-dev
# private-tmp - problems with multiple browser sessions

noexec ${HOME}
noexec /tmp

# the file dialog needs to work without d-bus
env NO_CHROME_KDE_FILE_DIALOG=1
