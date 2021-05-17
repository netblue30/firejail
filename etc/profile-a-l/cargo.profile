# Firejail profile for cargo
# Description: The Rust package manager
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include cargo.local
# Persistent global definitions
include globals.local

ignore noexec ${HOME}
ignore noexec /tmp

blacklist /tmp/.X11-unix
blacklist ${RUNUSER}

noblacklist ${HOME}/.cargo/credentials
noblacklist ${HOME}/.cargo/credentials.toml

# Allows files commonly used by IDEs
include allow-common-devel.inc

# Allow ssh (blacklisted by disable-common.inc)
#include allow-ssh.inc

include disable-common.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

#mkdir ${HOME}/.cargo
#whitelist ${HOME}/YOUR_CARGO_PROJECTS
#whitelist ${HOME}/.cargo
#whitelist ${HOME}/.rustup
#include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
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
seccomp.block-secondary
shell none
tracelog

disable-mnt
#private-bin cargo,rustc
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,group,host.conf,hostname,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,localtime,magic,magic.mgc,nsswitch.conf,passwd,pki,protocols,resolv.conf,rpc,services,ssl
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
read-write ${HOME}/.cargo/bin
