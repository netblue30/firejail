# Firejail profile for filezilla
# Description: Full-featured graphical FTP/FTPS/SFTP client
# This file is overwritten after every install/update
# Persistent local customizations
include filezilla.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/filezilla
noblacklist ${HOME}/.filezilla

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*
noblacklist /usr/local/lib/python2*
noblacklist /usr/local/lib/python3*

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc
include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

# private-bin breaks --join if the user has zsh set as $SHELL - adding zsh on private-bin
private-bin filezilla,uname,sh,bash,zsh,python*,lsb_release,fzputtygen,fzsftp
private-dev
private-tmp
