# qTox instant messaging profile
noblacklist ${HOME}/.config/tox
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

mkdir ${HOME}/.config/tox
whitelist ${HOME}/.config/tox
whitelist ${DOWNLOADS}

caps.drop all
netfilter
nogroups
nonewprivs
noroot
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin qtox
private-tmp
