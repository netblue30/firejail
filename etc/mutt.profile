# mutt email client profile

noblacklist ~/.muttrc
noblacklist ~/.mutt/muttrc
noblacklist ~/.gnupg
noblacklist ~/.mail
noblacklist ~/.Mail
noblacklist ~/mail
noblacklist ~/Mail
noblacklist ~/.cache/mutt

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-devel.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
nosound
protocol unix,inet,inet6
seccomp
shell none

private-bin mutt
private-dev
private-etc
# private-tmp
# whitelist /tmp/.X11-unix
