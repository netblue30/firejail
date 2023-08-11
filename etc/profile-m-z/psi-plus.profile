# Firejail profile for psi-plus
# Description: Qt-based XMPP/Jabber client
# This file is overwritten after every install/update
# Persistent local customizations
include psi-plus.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/psi+
noblacklist ${HOME}/.local/share/psi+

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.cache/psi+
mkdir ${HOME}/.config/psi+
mkdir ${HOME}/.local/share/psi+
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/psi+
whitelist ${HOME}/.config/psi+
whitelist ${HOME}/.local/share/psi+
include whitelist-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
# QtWebengine needs chroot to set up its own sandbox
seccomp !chroot

disable-mnt
private-dev
private-tmp

#restrict-namespaces
