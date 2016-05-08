# Totem media player profile
noblacklist ~/.config/totem
noblacklist ~/.local/share/totem

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
seccomp
protocol unix,inet,inet6
noroot
netfilter

mkdir ~/.config
mkdir ~/.config/totem
whitelist ~/.config/totme

mkdir ~/.local
mkdir ~/.local/share
mkdir ~/.local/share/totem
whitelist ~/.local/share/totem
