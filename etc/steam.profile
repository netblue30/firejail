# Firejail profile for steam
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/steam.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.java
noblacklist ${HOME}/.killingfloor
noblacklist ${HOME}/.local/share/3909/PapersPlease
noblacklist ${HOME}/.local/share/aspyr-media
noblacklist ${HOME}/.local/share/cdprojektred
noblacklist ${HOME}/.local/share/feral-interactive
noblacklist ${HOME}/.local/share/Steam
noblacklist ${HOME}/.local/share/SuperHexagon
noblacklist ${HOME}/.local/share/Terraria
noblacklist ${HOME}/.local/share/vpltd
noblacklist ${HOME}/.local/share/vulkan
noblacklist ${HOME}/.steam
noblacklist ${HOME}/.steampath
noblacklist ${HOME}/.steampid
# with >=llvm-4 mesa drivers need llvm stuff
noblacklist /usr/lib/llvm*
# needed for STEAM_RUNTIME_PREFER_HOST_LIBRARIES=1 to work
noblacklist /sbin

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
# novideo should be commented for VR
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none
# tracelog disabled as it breaks integrated browser
# tracelog

# private-dev should be commented for controllers
private-dev
# private-etc breaks some games
#private-etc asound.conf,ca-certificates,dbus-1,drirc,fonts,group,gtk-2.0,gtk-3.0,host.conf,hostname,hosts,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,localtime,lsb-release,machine-id,mime.types,passwd,pulse,resolv.conf,ssl
private-tmp
