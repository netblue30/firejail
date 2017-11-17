# Firejail profile for qupzilla
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/qupzilla.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/qupzilla
noblacklist ${HOME}/.config/qupzilla

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/qupzilla
whitelist ${HOME}/.config/qupzilla
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nodvd
noroot
notv
protocol unix,inet,inet6,netlink
seccomp
tracelog

# private-etc passwd,group,hostname,hosts,localtime,nsswitch.conf,resolv.conf,gtk-2.0,pango,fonts,iceweasel,firefox,adobe,mime.types,mailcap,asound.conf,pulse
