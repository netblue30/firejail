# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/libreoffice.local

# Firejail profile for LibreOffice
noblacklist ~/.config/libreoffice
noblacklist /usr/local/sbin
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-dev
# whitelist /tmp/.X11-unix/

noexec ${HOME}
noexec ${HOME}/.local/share
noexec /tmp
