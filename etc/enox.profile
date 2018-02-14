# Firejail profile for dnox
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/enox.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/Enox
noblacklist ${HOME}/.config/Enox
noblacklist ${HOME}/.pki

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.cache/dnox
mkdir ${HOME}/.config/dnox
mkdir ${HOME}/.pki
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/Enox
whitelist ${HOME}/.config/Enox
whitelist ${HOME}/.pki
include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

caps.keep sys_chroot,sys_admin
netfilter
nodvd
nogroups
notv
shell none

private-dev
# private-tmp - problems with multiple browser sessions

noexec ${HOME}
noexec /tmp
