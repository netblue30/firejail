# zathura document viewer profile
noblacklist ~/.config/zathura
noblacklist ~/.local/share/zathura
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
seccomp
protocol unix
netfilter
nonewprivs
noroot
nosound

#net none
shell none
#private-etc X11
