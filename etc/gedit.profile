# Firejail profile for gedit
# Description: Official text editor of the GNOME desktop environment
# This file is overwritten after every install/update
# Persistent local customizations
include gedit.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/enchant
noblacklist ${HOME}/.config/gedit
noblacklist ${HOME}/.config/git
noblacklist ${HOME}/.gitconfig
noblacklist ${HOME}/.git-credentials
noblacklist ${HOME}/.python-history
noblacklist ${HOME}/.pythonrc.py

include disable-common.inc
# include disable-devel.inc
include disable-exec.inc
# include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

# apparmor - makes settings immutable
caps.drop all
machine-id
# net none - makes settings immutable
no3d
# nodbus - makes settings immutable
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

# private-bin gedit
private-dev
# private-etc alternatives,fonts
private-lib aspell,gconv,gedit,libgspell-1.so.*,libreadline.so.*,libtinfo.so.*
private-tmp

