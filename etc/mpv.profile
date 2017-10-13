# Firejail profile for mpv
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/mpv.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/mpv
noblacklist ${HOME}/.netrc

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin mpv,youtube-dl,python*,env
private-dev
