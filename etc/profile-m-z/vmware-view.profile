# Firejail profile for vmware-view
# Description: VMware Horizon Client
# This file is overwritten after every install/update
# Persistent local customizations
include vmware-view.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.vmware

noblacklist /sbin
noblacklist /usr/sbin

include allow-bin-sh.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.vmware
whitelist ${HOME}/.vmware
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
# Add 'ignore novideo' to your vmware-view.local if you need your webcam.
novideo
protocol unix,inet,inet6
seccomp !iopl
seccomp.block-secondary
shell none
tracelog

disable-mnt
private-cache
private-dev
private-etc alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dconf,drirc,fonts,gai.conf,gconf,glvnd,group,gtk-2.0,gtk-3.0,host.conf,hostname,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,localtime,login.defs,machine-id,magic,magic.mgc,mime.types,nsswitch.conf,nvidia,pango,passwd,pki,protocols,proxychains.conf,pulse,resolv.conf,rpc,services,ssl,terminfo,vmware,vmware-tools,vmware-vix,X11,xdg
# Logs are kept in /tmp. Add 'ignore private-tmp' to your vmware-view.local if you need them without joining the sandbox.
private-tmp

dbus-user none
dbus-system none
