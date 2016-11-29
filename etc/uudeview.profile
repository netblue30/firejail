# uudeview profile
quiet
ignore noroot
include /etc/firejail/default.profile

blacklist /etc

hostname uudeview
net none
nosound
shell none
tracelog

private-bin uudeview
private-dev
