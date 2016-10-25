# Firejail profile for the Tor Brower Bundle
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin bash,grep,sed,tail,env,gpg,id,readlink,dirname,test,mkdir,ln,sed,cp,rm,getconf
private-etc fonts
private-dev
private-tmp
