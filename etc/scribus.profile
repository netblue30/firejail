# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/scribus.local

# Firejail profile for Scribus
noblacklist ~/.scribus
noblacklist ~/.config/scribus
noblacklist ~/.config/scribusrc
noblacklist ~/.local/share/scribus
noblacklist ~/.gimp*

# Support for PDF readers (Scribus 1.5 and higher)
noblacklist ~/.kde4/share/apps/okular
noblacklist ~/.kde4/share/config/okularrc
noblacklist ~/.kde4/share/config/okularpartrc
noblacklist ~/.kde/share/apps/okular
noblacklist ~/.kde/share/config/okularrc
noblacklist ~/.kde/share/config/okularpartrc
noblacklist ~/.local/share/okular
noblacklist ~/.config/okularrc
noblacklist ~/.config/okularpartrc

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
nonewprivs
noroot
nosound
protocol unix
seccomp
tracelog

private-dev
#private-tmp
