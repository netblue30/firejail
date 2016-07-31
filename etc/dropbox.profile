# dropbox profile
noblacklist ~/.config/autostart
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

caps
nonewprivs
noroot
protocol unix,inet,inet6
seccomp

mkdir ~/Dropbox
whitelist ~/Dropbox
mkdir ~/.dropbox
whitelist ~/.dropbox
mkdir ~/.dropbox-dist
whitelist ~/.dropbox-dist

mkfile ~/.config/autostart/dropbox.desktop
whitelist ~/.config/autostart/dropbox.desktop
