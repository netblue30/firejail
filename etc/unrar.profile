# unrar profile
quiet
ignore noroot
include /etc/firejail/default.profile

tracelog
net none
shell none
private-bin unrar
private-dev
nosound
no3d
private-etc passwd,group,localtime
hostname unrar
private-tmp
blacklist /tmp/.X11-unix

