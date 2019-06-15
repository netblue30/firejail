# Firejail profile for ghostwriter
# Description: Cross-platform, aesthetic, distraction-free Markdown editor.
# This file is overwritten after every install/update
# Persistent local customizations
include ghostwriter.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/ghostwriter
noblacklist ${DOCUMENTS}
noblacklist ${PICTURES}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

#mkdir ${HOME}/.config/ghostwriter
#whitelist ${HOME}/.config/ghostwriter
#whitelist ${DESKTOP}
#whitelist ${DOCUMENTS}
#whitelist ${DOWNLOADS}
#whitelist ${PICTURES}
#include whitelist-common.inc

apparmor
caps.drop all
machine-id
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

# Breaks Translation
#private-bin ghostwriter,pandoc
private-cache
private-dev
private-etc alternatives,crypto-policies,cups,dconf,drirc,fonts,gtk-3.0,localtime,machine-id
# Breaks Translation
#private-lib
private-tmp

