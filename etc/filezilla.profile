# Firejail profile for filezilla
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/filezilla.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/filezilla
noblacklist ${HOME}/.filezilla

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

private-bin filezilla,uname,sh,bash,python*,lsb_release,fzputtygen,fzsftp
private-dev
private-tmp
