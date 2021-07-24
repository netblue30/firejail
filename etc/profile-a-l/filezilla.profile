# Firejail profile for filezilla
# Description: Full-featured graphical FTP/FTPS/SFTP client
# This file is overwritten after every install/update
# Persistent local customizations
include filezilla.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/filezilla
nodeny  ${HOME}/.filezilla

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

# Allow ssh (blacklisted by disable-common.inc)
include allow-ssh.inc

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc

include whitelist-runuser-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
noinput
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
private-bin bash,filezilla,fzputtygen,fzsftp,lsb_release,python*,sh,uname,zsh
private-dev
private-tmp
