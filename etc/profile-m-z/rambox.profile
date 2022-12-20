# Firejail profile for rambox
# Description: Free and Open Source messaging and emailing app that combines common web applications into one (Electron-based)
# This file is overwritten after every install/update
# Persistent local customizations
include rambox.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Rambox
noblacklist ${HOME}/.local/share/pki
noblacklist ${HOME}/.pki

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.config/Rambox
mkdir ${HOME}/.local/share/pki
mkdir ${HOME}/.pki
whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/Rambox
whitelist ${HOME}/.local/share/pki
whitelist ${HOME}/.pki
include whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
# electron-based application, needing chroot
#seccomp
seccomp !chroot
#tracelog

#restrict-namespaces
