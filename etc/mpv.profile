# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/mpv.local

# mpv media player profile
noblacklist ${HOME}/.config/mpv
noblacklist ${HOME}/.netrc

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
tracelog

# to test
# ipc-namespace
shell none
private-bin mpv,youtube-dl,python,python2.7,python3.6,env
private-dev
