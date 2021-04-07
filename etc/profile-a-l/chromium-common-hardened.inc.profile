# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include chromium-common-hardened.inc.local

caps.drop all
nonewprivs
noroot
protocol unix,inet,inet6,netlink
# kcmp is required for ozone-platform=wayland, see #3783.
seccomp !chroot,!kcmp
