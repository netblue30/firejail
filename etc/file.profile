# file profile
ignore noroot
include /etc/firejail/default.profile

blacklist /tmp/.X11-unix

hostname file
net none
no3d
nosound
quiet
shell none
tracelog

private-dev
private-bin file
private-etc magic.mgc,magic,localtime
