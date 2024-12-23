# Firejail profile for syncthing
# Description: File synchronization using public networks
# This file is overwritten after every install/update

# Persistent local customizations
include syncthing.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/state/syncthing
# NOTE: this assumes a ~/Sync directory to be shared by default. Maybe leave a requirement to edit local file to set dirs?
noblacklist ${HOME}/Sync

# NOTE: will cause WARNING: Failed to lower process
#       priority: set I/O priority: operation not permitted
#       So, we try to preemptively set it here:
nice 2

blacklist ${RUNUSER}
blacklist ${RUNUSER}/wayland-*
blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.local/state/syncthing
mkdir ${HOME}/Sync
whitelist ${HOME}/.local/state/syncthing
whitelist ${HOME}/Sync
include whitelist-common.inc

#apparmor
caps.drop all
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noprinters
noroot
nosound
#notpm # this line causes error
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
##seccomp !chroot
##seccomp.drop SYSCALLS (see syscalls.txt)
#seccomp.block-secondary
##seccomp-error-action log (only for debugging seccomp issues)
#tracelog
#x11 none # desirable but too complex to add

disable-mnt
private-cache
private-dev
#private-etc
#  Networking: ca-certificates,crypto-policies,host.conf,hostname,hosts,nsswitch.conf,pki,protocols,resolv.conf,rpc,services,ssl
#private-tmp

dbus-user none
dbus-system none

restrict-namespaces

