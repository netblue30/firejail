include disable-common.inc
include disable-devel.inc
include disable-passwdmgr.inc
include disable-programs.inc
include globals.local

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp

private-bin sh,xdg-mime,tr,sed,echo,head,cut,xdg-open,grep,egrep,bash,zsh,teams-for-linux
private-dev
private-etc fonts,machine-id,localtime,ld.so.cache,ca-certificates,ssl,pki,crypto-policies,resolv.conf
private-tmp
disable-mnt

noblacklist ${HOME}/.config/teams-for-linux
whitelist ${HOME}/.config/teams-for-linux
noexec /tmp
