# Firejail profile for kwrite
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/kwrite.local
# Persistent global definitions
include /etc/firejail/globals.local

# blacklist /run/user/*/bus

noblacklist ${HOME}/.config/katepartrc
noblacklist ${HOME}/.config/katerc
noblacklist ${HOME}/.config/kateschemarc
noblacklist ${HOME}/.config/katesyntaxhighlightingrc
noblacklist ${HOME}/.config/katevirc
noblacklist ${HOME}/.config/kwriterc
noblacklist ${HOME}/.local/share/kwrite

include /etc/firejail/disable-common.inc
# include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
# net none
netfilter
nodvd
nogroups
nonewprivs
noroot
# nosound - KWrite is using ALSA!
notv
novideo
protocol unix
seccomp
shell none
tracelog

# private-bin kwrite
private-dev
# private-etc fonts
private-tmp
