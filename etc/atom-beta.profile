# Firjail profile for Atom Beta.
noblacklist ~/.atom
noblacklist ~/.config/Atom

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nonewprivs
nogroups
noroot
seccomp
shell none

private-dev
nosound

