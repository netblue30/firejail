# Firejail profile for ghostwriter
# Description: Cross-platform, aesthetic, distraction-free Markdown editor.
# This file is overwritten after every install/update
# Persistent local customizations
include ghostwriter.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/ghostwriter

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.config/ghostwriter
whitelist ${HOME}/.config/ghostwriter
include whitelist-common.inc

apparmor
caps.drop all
netfilter
#no3d
#nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,netlink
seccomp
shell none
tracelog
machine-id

# Breaks Translation
#private-bin ghostwriter,pandoc
private-cache
private-dev
private-etc cups,crypto-policies,localtime,drirc,fonts,xdg,gtk-3.0,dconf,machine-id
# Breaks Translation
#private-lib
private-tmp

noexec ${HOME}
noexec /tmp
