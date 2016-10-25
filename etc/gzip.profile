# gzip profile
ignore noroot
include /etc/firejail/default.profile

blacklist /tmp/.X11-unix

net none
no3d
nosound
quiet
shell none
tracelog

private-dev
