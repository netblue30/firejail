# uudeview profile
quiet
ignore noroot
include /etc/firejail/default.profile


hostname uudeview
net none
nosound
shell none
tracelog

private-bin uudeview
private-dev
private-etc ld.so.preload
