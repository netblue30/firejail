# Firejail profile for multimc5
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/multimc5.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.java
noblacklist ${HOME}/.local/share/multimc
noblacklist ${HOME}/.local/share/multimc5
noblacklist ${HOME}/.multimc5

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.local/share/multimc
whitelist ${HOME}/.local/share/multimc
whitelist ${HOME}/.local/share/multimc5
whitelist ${HOME}/.multimc5
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
# seccomp
shell none

disable-mnt
# private-bin works, but causes weirdness
# private-bin multimc5,dash,bash,mkdir,which,zenity,kdialog,ldd,chmod,valgrind,apt-file,pkgfile,dnf,yum,zypper,pfl,java,grep,sort,awk,readlink,dirname
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
