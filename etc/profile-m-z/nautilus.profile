# Firejail profile for nautilus
# Description: File manager and graphical shell for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include nautilus.local
# Persistent global definitions
include globals.local

# Nautilus is started by systemd on most systems. Therefore it is not firejailed by default. Since there
# is already a nautilus process running on gnome desktops firejail will have no effect.

noblacklist ${HOME}/.config/nautilus
noblacklist ${HOME}/.local/share/Trash
noblacklist ${HOME}/.local/share/nautilus
noblacklist ${HOME}/.local/share/nautilus-python

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
# include disable-programs.inc

allusers
caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix
seccomp
shell none
tracelog

# nautilus needs to be able to start arbitrary applications so we cannot blacklist their files
# private-bin nautilus
# private-dev
# private-tmp
