# Firejail profile for syncthing
# Description: File synchronization using public networks
# This file is overwritten after every install/update

##quiet
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

# no allow-*.inc

##blacklist PATH
# Disable Wayland
blacklist ${RUNUSER}/wayland-*
# Disable RUNUSER (cli only; supersedes Disable Wayland)
blacklist ${RUNUSER}
# Remove the next blacklist if your system has no /usr/libexec dir,
# otherwise try to add it.
blacklist /usr/libexec

# disable-*.inc includes
include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
#include disable-write-mnt.inc # we set disable-mnt
#include disable-x11.inc # this causes an error...
include disable-xdg.inc


mkdir ${HOME}/.local/state/syncthing
whitelist ${HOME}/.local/state/syncthing

# see note above about this dir!
mkdir ${HOME}/Sync
whitelist ${HOME}/Sync

include whitelist-common.inc


# Landlock commands
##landlock.fs.read PATH
##landlock.fs.write PATH
##landlock.fs.makeipc PATH
##landlock.fs.makedev PATH
##landlock.fs.execute PATH
#include landlock-common.inc

##allusers
#apparmor
caps.drop all
# CLI only
##ipc-namespace
# breaks audio and sometimes dbus related functions
#machine-id
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
#private-bin PROGRAMS
private-cache
private-dev
#private-etc
#  Networking: ca-certificates,crypto-policies,host.conf,hostname,hosts,nsswitch.conf,pki,protocols,resolv.conf,rpc,services,ssl
##private-lib LIBS
#private-tmp
##writable-etc
##writable-run-user
##writable-var
##writable-var-log

dbus-user none
dbus-system none

# Note: read-only entries should usually go in disable-common.inc (especially
# entries for configuration files that allow arbitrary command execution).
##deterministic-shutdown
##env VAR=VALUE
# NOTE: there's no env to avoid starting the browser, but it will err out just "fine".
##join-or-start NAME
#memory-deny-write-execute
##read-write ${HOME}
restrict-namespaces

