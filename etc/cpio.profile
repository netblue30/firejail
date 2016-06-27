# cpio profile
# testing: find . -print -depth | cpio -ov > tree.cpio
include /etc/firejail/default.profile
tracelog
net none
shell none
private-bin cpio
private-dev


