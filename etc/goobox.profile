# goobox profile
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
nogroups
nonewprivs
noroot
protocol unix
seccomp
netfilter
shell none
tracelog

# private-bin goobox
# private-tmp
# private-dev
# private-etc fonts
