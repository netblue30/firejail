# XChat IRC profile
noblacklist ${HOME}/.config/xchat

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

caps.drop all
nonewprivs
noroot
protocol unix,inet,inet6
seccomp

# private-bin requires perl, python, etc.
