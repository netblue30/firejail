# unrar profile
quiet
ignore noroot
include /etc/firejail/default.profile

blacklist /tmp/.X11-unix

hostname unrar
net none
no3d
nosound
shell none
tracelog

private-bin unrar
private-dev
private-etc passwd,group,localtime
private-tmp
