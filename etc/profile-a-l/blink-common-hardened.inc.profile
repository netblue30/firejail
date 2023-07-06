# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include blink-common-hardened.inc.local

caps.drop all
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp !chroot

#restrict-namespaces
