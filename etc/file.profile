# file profile
quiet
ignore noroot
include /etc/firejail/default.profile

tracelog
net none
shell none
private-bin file
private-etc magic.mgc,magic,localtime
hostname file
private-dev
nosound
no3d
blacklist /tmp/.X11-unix

