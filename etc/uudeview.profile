# uudeview profile
quiet
ignore noroot
include /etc/firejail/default.profile

tracelog
net none
shell none
private-bin uudeview
private-dev
private-etc nonexisting_fakefile_for_empty_etc
hostname uudeview
nosound
uudeview

