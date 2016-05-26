# deluge bittorernt client profile
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
# deluge is using python on Debian
#include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
seccomp
protocol unix,inet,inet6
netfilter
nonewprivs
noroot
nosound
