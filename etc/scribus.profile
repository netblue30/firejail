# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/scribus.local

# Firejail profile for Scribus
noblacklist ~/.scribus
noblacklist ~/.config/scribus
noblacklist ~/.local/share/scribus
noblacklist ~/.gimp*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
nonewprivs
noroot
protocol unix
seccomp
tracelog

private-dev
#private-tmp
