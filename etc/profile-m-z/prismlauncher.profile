# Custom profile for prismlauncher

# file system
include /etc/firejail/disable-common.inc
whitelist ~/.local/share/PrismLauncher
read-only ~/Downloads
include /etc/firejail/whitelist-common.inc
private-tmp
private-dev
disable-mnt
blacklist /mnt
blacklist /media
blacklist /sbin

# network
net enp4s0f3u2u1u2
netfilter
dns 8.8.8.8
dns 1.1.1.1

# multimedia
nodvd
novideo
notv
notpm
noprinters
nodbus

# kernel
seccomp
nonewprivs
caps.drop all
noroot
apparmor
