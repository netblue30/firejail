# Firejail profile for chromium-common
# This file is overwritten after every install/update
# Persistent local customizations
include chromium-common.local
# Persistent global definitions
# already included by caller profile
#include globals.local

noblacklist ${HOME}/.pki
noblacklist ${HOME}/.local/share/pki

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.pki
mkdir ${HOME}/.local/share/pki
whitelist ${DOWNLOADS}
whitelist ${HOME}/.pki
whitelist ${HOME}/.local/share/pki
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.keep sys_chroot,sys_admin
netfilter
# Breaks Gnome connector - disable if you use that
nodbus
nodvd
nogroups
notv
?BROWSER_DISABLE_U2F: nou2f
shell none

disable-mnt
private-dev
# private-tmp - problems with multiple browser sessions

# breaks DRM binaries
#noexec ${HOME}
noexec /tmp

# the file dialog needs to work without d-bus
env NO_CHROME_KDE_FILE_DIALOG=1
