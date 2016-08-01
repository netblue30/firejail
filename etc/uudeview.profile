# uudeview profile
# the default profile will disable root user, enable seccomp filter etc.
quiet
ignore noroot
include /etc/firejail/default.profile

tracelog
net none
shell none
private-bin uudeview
private-dev
private-tmp
private-etc nonexisting_fakefile_for_empty_etc
hostname uudeview
nosound
