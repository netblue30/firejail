# Firejail profile for akregator
# Description: RSS/Atom feed aggregator
# This file is overwritten after every install/update
# Persistent local customizations
include akregator.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/akregatorrc
noblacklist ${HOME}/.local/share/akregator

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkfile ${HOME}/.config/akregatorrc
mkdir ${HOME}/.local/share/akregator
whitelist ${HOME}/.config/akregatorrc
whitelist ${HOME}/.local/share/akregator
whitelist ${HOME}/.local/share/kssl
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
# chroot syscalls are needed for setting up the built-in sandbox
seccomp !chroot
shell none

disable-mnt
private-bin akregator,akregatorstorageexporter,dbus-launch,kdeinit4,kdeinit4_shutdown,kdeinit4_wrapper,kdeinit5,kdeinit5_shutdown,kdeinit5_wrapper,kshell4,kshell5
private-dev
#private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,ca-certificates,crypto-policies,dbus-1,fonts,hosts,host.conf,hostname,kde4rc,kde5rc,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,tor,xdg
private-tmp

