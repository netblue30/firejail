# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/evolution.local

# evolution profile
noblacklist ~/.config/evolution
noblacklist ~/.local/share/evolution
noblacklist ~/.cache/evolution
noblacklist ~/.pki
noblacklist ~/.pki/nssdb
noblacklist ~/.gnupg
noblacklist ~/.bogofilter

noblacklist /var/spool/mail
noblacklist /var/mail

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
no3d
nogroups
nonewprivs
noroot
nosound
protocol unix,inet,inet6
seccomp
shell none

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
