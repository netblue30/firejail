# file profile
quiet
ignore noroot
include /etc/firejail/default.profile

tracelog
net none
shell none
private-bin file
private-dev
private-etc magic.mgc,magic,localtime
hostname file
nosound
