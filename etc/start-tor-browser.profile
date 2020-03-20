# Firejail profile for start-tor-browser
# This file is overwritten after every install/update
# Persistent local customizations
include start-tor-browser.local
# Persistent global definitions
include globals.local

ignore noexec ${HOME}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

#X11: include whitelist-runuser-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp !chroot
shell none
# tracelog may cause issues, see github issue #1930
#tracelog

disable-mnt
private-bin bash,cat,cp,cut,dirname,env,getconf,gpg,grep,gxmessage,id,kdialog,ln,mkdir,pwd,readlink,realpath,rm,sed,sh,tail,test,update-desktop-database,xmessage,zenity
private-dev
private-etc alsa,alternatives,asound.conf,ca-certificates,crypto-policies,fonts,hostname,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,machine-id,pki,pulse,resolv.conf,ssl
private-tmp
