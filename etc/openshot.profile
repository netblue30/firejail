# OpenShot profile
noblacklist ${HOME}/.openshot
noblacklist ${HOME}/.openshot_qt
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp
