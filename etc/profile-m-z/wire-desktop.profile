# Firejail profile for wire-desktop
# Description: End-to-end encrypted messenger with file sharing, voice calls and video conferences
# This file is overwritten after every install/update
# Persistent local customizations
include wire-desktop.local
# Persistent global definitions
# added by included profile
#include globals.local

# Debian/Ubuntu use /opt/Wire. As that is not in PATH by default, run `firejail /opt/Wire/wire-desktop` to start it.

ignore dbus-user none
ignore dbus-system none

noblacklist ${HOME}/.config/Wire

include disable-devel.inc
include disable-interpreters.inc

mkdir ${HOME}/.config/Wire
whitelist ${HOME}/.config/Wire
include whitelist-common.inc

nou2f
ignore seccomp
seccomp !chroot
shell none

disable-mnt
private-bin bash,electron,electron[0-9],electron[0-9][0-9],env,sh,wire-desktop
private-dev
private-etc alternatives,ca-certificates,crypto-policies,fonts,machine-id,pki,resolv.conf,ssl
private-tmp

# Redirect
include electron.profile
