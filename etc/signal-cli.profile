# Firejail profile for signal-cli
# Description: signal-cli provides a commandline and dbus interface for signalapp/libsignal-service-java
# This file is overwritten after every install/update
# Persistent local customizations
include signal-cli.local
# Persistent global definitions
include globals.local

blacklist /tmp/.X11-unix

noblacklist ${HOME}/.local/share/signal-cli

include allow-java.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.local/share/signal-cli
whitelist ${HOME}/.local/share/signal-cli
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
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

disable-mnt
private-bin java,sh,signal-cli
private-cache
private-dev
# Does not work with all Java configurations. You will notice immediately, so you might want to give it a try
#private-etc alternatives,ca-certificates,crypto-policies,dbus-1,host.conf,hostname,hosts,java-10-openjdk,java-7-openjdk,java-8-openjdk,java-9-openjdk,java.conf,machine-id,nsswitch.conf,passwd,pki,protocols,resolv.conf,rpc,services,ssl
private-tmp
