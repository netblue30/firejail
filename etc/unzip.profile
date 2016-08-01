# unzip profile
quiet
ignore noroot
include /etc/firejail/default.profile

tracelog
net none
shell none
private-bin unzip
private-dev
private-etc passwd,group,localtime
hostname unzip
nosound
