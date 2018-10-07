# Firejail profile for filezilla
# Description: Full-featured graphical FTP/FTPS/SFTP client
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/filezilla.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/filezilla
noblacklist ${HOME}/.filezilla

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
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
