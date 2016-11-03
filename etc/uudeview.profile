# uudeview profile
ignore noroot
include /etc/firejail/default.profile

blacklist /etc

hostname uudeview
net none
nosound
quiet
shell none
tracelog

private-bin uudeview
private-dev
