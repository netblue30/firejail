# Firejail profile for parole
# Description: Media player based on GStreamer framework
# This file is overwritten after every install/update
# Persistent local customizations
include parole.local
# Persistent global definitions
include globals.local

noblacklist ${MUSIC}
noblacklist ${VIDEOS}

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

caps.drop all
netfilter
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp

private-bin dbus-launch,parole
private-cache
private-etc @tls-ca

restrict-namespaces
