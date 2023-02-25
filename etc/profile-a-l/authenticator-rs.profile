# Firejail profile for authenticator-rs
# Description: Rust based 2FA authentication program
# This file is overwritten after every install/update
# Persistent local customizations
include authenticator-rs.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/authenticator-rs

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.local/share/authenticator-rs
whitelist ${HOME}/.local/share/authenticator-rs
whitelist ${DOWNLOADS}
whitelist /usr/share/uk.co.grumlimited.authenticator-rs
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
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
tracelog

disable-mnt
private-bin authenticator-rs
private-cache
private-dev
private-etc @tls-ca,@x11
private-tmp

dbus-user filter
dbus-user.talk ca.desrt.dconf
dbus-system none

restrict-namespaces
