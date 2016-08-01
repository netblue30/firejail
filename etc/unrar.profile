# unrar profile
quiet
ignore noroot
include /etc/firejail/default.profile

tracelog
net none
shell none
private-bin unrar
private-dev
private-etc passwd,group,localtime
hostname unrar
nosound
