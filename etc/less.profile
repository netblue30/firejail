# less profile
quiet
ignore noroot
include /etc/firejail/default.profile

net none
nosound
no3d
shell none
tracelog

blacklist /tmp/.X11-unix

private-dev
