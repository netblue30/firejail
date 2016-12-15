# deluge bittorrernt client profile
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
# deluge is using python on Debian
#include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nonewprivs
noroot
nosound
protocol unix,inet,inet6
seccomp

shell none
#private-bin deluge,sh,python,uname
private-dev
private-tmp

