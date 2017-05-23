# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/xreader.local

# Xreader profile
noblacklist ~/.config/xreader
noblacklist ~/.local/share
noblacklist ~/.cache/xreader

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
nogroups
nonewprivs
noroot
nosound
protocol unix
seccomp
shell none
tracelog

private-bin xreader, xreader-previewer, xreader-thumbnailer
private-dev
private-tmp
