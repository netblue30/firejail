# Google Play Music desktop player profile
noblacklist ~/.config/Google Play Music Desktop Player

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
seccomp
protocol unix,inet,inet6,netlink
nonewprivs
noroot
netfilter

#whitelist ~/.pulse
#whitelist ~/.config/pulse
whitelist ~/.config/Google Play Music Desktop Player
