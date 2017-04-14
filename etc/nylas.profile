# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/nylas.local

# Firejail profile for Nylas Mail
noblacklist ~/.config/Nylas Mail
noblacklist ~/.nylas-mail

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

whitelist ~/.config/Nylas Mail
whitelist ~/.nylas-mail
whitelist ${DOWNLOADS}
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
nosound
protocol unix,inet,inet6,netlink
seccomp
shell none

private-dev
