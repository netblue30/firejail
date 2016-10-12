################################
# xpdf application profile
################################
#include /etc/firejail/disable-common.inc
#include /etc/firejail/disable-programs.inc
#include /etc/firejail/disable-passwdmgr.inc

caps.drop all
shell none

nonewprivs
noroot
protocol unix
seccomp


noblacklist /etc/xpdfrc
noblacklist ${HOME}/.xpdfrc


private-dev
private-tmp



