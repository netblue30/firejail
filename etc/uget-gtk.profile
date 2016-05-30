# uGet profile
noblacklist ${HOME}/.config/uGet

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

caps.drop all
netfilter
nonewprivs
noroot
protocol unix,inet,inet6
seccomp

whitelist ${DOWNLOADS}
mkdir ~/.config
mkdir ~/.config/uGet
whitelist ~/.config/uGet
include /etc/firejail/whitelist-common.inc
