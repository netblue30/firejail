# uGet profile
noblacklist ${HOME}/.config/uGet

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

caps.drop all
netfilter
nonewprivs
noroot
nosound
protocol unix,inet,inet6
seccomp
shell none

private-bin uget-gtk
private-dev
private-tmp

whitelist ${DOWNLOADS}
mkdir ~/.config/uGet
whitelist ~/.config/uGet
include /etc/firejail/whitelist-common.inc
