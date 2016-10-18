# evolution profile

noblacklist ~/.config/evolution
noblacklist ~/.local/share/evolution
noblacklist ~/.cache/evolution
noblacklist ~/.pki
noblacklist ~/.pki/nssdb
noblacklist ~/.gnupg

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nonewprivs
noroot
nogroups
protocol unix,inet,inet6
seccomp
shell none

private-dev
private-tmp
