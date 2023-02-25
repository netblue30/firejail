# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include ping-hardened.inc.local

caps.drop all
nonewprivs
noroot
protocol unix,inet,inet6
seccomp

memory-deny-write-execute
restrict-namespaces
