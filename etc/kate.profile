# Firejail profile for kate
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/kate.local
# Persistent global definitions
include /etc/firejail/globals.local

# blacklist /run/user/*/bus

# warning: full filesystem access is granted, allows system administration. Uncomment below  if you want.

# noblacklist ${HOME}/.config/katepartrc
# noblacklist ${HOME}/.config/katerc
# noblacklist ${HOME}/.config/kateschemarc
# noblacklist ${HOME}/.config/katesyntaxhighlightingrc
# noblacklist ${HOME}/.config/katevirc
# noblacklist ${HOME}/.local/share/kate

# include /etc/firejail/disable-common.inc
# include /etc/firejail/disable-devel.inc
# include /etc/firejail/disable-passwdmgr.inc
# include /etc/firejail/disable-programs.inc

# include /etc/firejail/whitelist-var-common.inc

caps.drop all
# net none
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none
tracelog

private-bin kate
private-dev
# private-etc fonts
private-tmp

noexec ${HOME}
noexec /tmp

join-or-start kate
