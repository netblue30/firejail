# Firejail profile for terasology
# This file is overwritten after every install/update
# Persistent local customizations
include terasology.local
# Persistent global definitions
include globals.local

ignore noexec /tmp

noblacklist ${HOME}/.local/share/terasology

# Allow java (blacklisted by disable-devel.inc)
include allow-java.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.java
mkdir ${HOME}/.local/share/terasology
whitelist ${HOME}/.java
whitelist ${HOME}/.local/share/terasology
include whitelist-common.inc

caps.drop all
ipc-namespace
net none
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp

disable-mnt
private-dev
private-etc @tls-ca,@x11,dbus-1,host.conf,java*,lsb-release,mime.types
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
