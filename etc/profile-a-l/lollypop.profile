# Firejail profile for lollypop
# Description: Music player for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include lollypop.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.local/share/lollypop
nodeny  ${MUSIC}

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
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

private-dev
private-etc alternatives,asound.conf,ca-certificates,crypto-policies,fonts,gtk-3.0,host.conf,hostname,hosts,machine-id,pki,pulse,resolv.conf,ssl,xdg
private-tmp

