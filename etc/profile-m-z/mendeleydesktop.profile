# Firejail profile for Mendeley
# Description: Academic software for managing and sharing research papers.
# This file is overwritten after every install/update
# Persistent local customizations
include mendeleydesktop.local
# Persistent global definitions
include globals.local

nodeny  ${DOCUMENTS}
nodeny  ${HOME}/.cache/Mendeley Ltd.
nodeny  ${HOME}/.config/Mendeley Ltd.
nodeny  ${HOME}/.local/share/Mendeley Ltd.
nodeny  ${HOME}/.local/share/data/Mendeley Ltd.
nodeny  ${HOME}/.pki
nodeny  ${HOME}/.local/share/pki

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

disable-mnt
private-bin cat,env,gconftool-2,ln,mendeleydesktop,python*,sh,update-desktop-database,which
private-dev
private-tmp

dbus-user none
dbus-system none
