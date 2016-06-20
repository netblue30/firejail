# mpv media player profile
noblacklist ${HOME}/.config/mpv

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nonewprivs
noroot
protocol unix,inet,inet6
seccomp

# to test
shell none
private-bin mpv,youtube-dl,python2.7
