################################
# xpdf application profile
################################
noblacklist ${HOME}/.xpdfrc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
shell none
nonewprivs
noroot
protocol unix
seccomp
private-dev
private-tmp
net none




