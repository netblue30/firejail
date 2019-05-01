# Firejail profile for bitwarden
# Description: A secure and free password manager for all of your devices
# This file is overwritten after every install/update.
# Persistent local customisations
include bitwarden.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Bitwarden
ignore noexec /tmp
noblacklist ${DOWNLOADS}

whitelist ${HOME}/.config/Bitwarden
whitelist ${HOME}/.config/gtk-3.0
whitelist ${HOME}/.fonts
whitelist ${HOME}/.icons
whitelist ${HOME}/.themes
whitelist ${DOWNLOADS}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
#nodbus - breaks appindicator (tray) functionality
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none
#tracelog - breaks on Arch

private-bin bitwarden
private-cache
?HAS_APPIMAGE: ignore private-dev
private-dev
private-etc alternatives,ca-certificates,crypto-policies,hosts,nsswitch.conf,fonts,pki,resolv.conf,ssl
private-opt Bitwarden
private-tmp

#memory-deny-write-execute - breaks on Arch
