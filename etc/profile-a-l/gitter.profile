# Firejail profile for gitter
# This file is overwritten after every install/update
# Persistent local customizations
include gitter.local
# Persistent global definitions
include globals.local

# To allow the program to autostart, add the following to gitter.local:
# Warning: This allows the program to easily escape the sandbox.
#noblacklist ${HOME}/.config/autostart
#whitelist ${HOME}/.config/autostart

noblacklist ${HOME}/.config/Gitter

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.config/Gitter
whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/Gitter
whitelist /opt/Gitter
include whitelist-var-common.inc

caps.drop all
machine-id
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
protocol unix,inet,inet6,netlink
seccomp

disable-mnt
private-bin bash,env,gitter
private-etc @tls-ca
private-dev
private-tmp

restrict-namespaces
