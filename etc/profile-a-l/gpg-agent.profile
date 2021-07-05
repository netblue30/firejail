# Firejail profile for gpg-agent
# Description: GNU privacy guard - cryptographic agent
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include gpg-agent.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.gnupg

deny  /tmp/.X11-unix
deny  ${RUNUSER}/wayland-*

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.gnupg
allow  ${HOME}/.gnupg
allow  ${RUNUSER}/gnupg
allow  ${RUNUSER}/keyring
allow  /usr/share/gnupg
allow  /usr/share/gnupg2
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
machine-id
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

# private-bin gpg-agent,gpg
private-cache
private-dev
