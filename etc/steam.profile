# Steam profile (applies to games/apps launched from Steam as well)
noblacklist ${HOME}/.steam
noblacklist ${HOME}/.local/share/steam
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

caps.drop all
netfilter
noroot
seccomp
protocol unix,inet,inet6
