# gzip profile
quiet
ignore noroot
include /etc/firejail/default.profile
tracelog
net none
shell none
blacklist /tmp/.X11-unix
private-dev
nosound
no3d

