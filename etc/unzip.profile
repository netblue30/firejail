# unzip profile
quiet
ignore noroot
include /etc/firejail/default.profile

tracelog
net none
shell none
private-bin unzip
private-etc passwd,group,localtime
hostname unzip
private-dev
nosound
no3d
blacklist /tmp/.X11-unix

