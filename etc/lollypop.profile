# Firejail profile for lollypop
# Description: Music player for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include lollypop.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.local/share/lollypop
noblacklist ${MUSIC}

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
netfilter
no3d
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

private-dev
private-etc alternatives,asound.conf,ca-certificates,fonts,host.conf,hostname,hosts,pulse,resolv.conf,ssl,pki,crypto-policies,gtk-3.0,xdg,machine-id
private-tmp

