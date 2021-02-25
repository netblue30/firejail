# Firejail profile for torbrowser-launcher
# Description: Helps download and run the Tor Browser Bundle
# This file is overwritten after every install/update
# Persistent local customizations
include torbrowser-launcher.local
# Persistent global definitions
include globals.local

ignore noexec ${HOME}

noblacklist ${HOME}/.config/torbrowser
noblacklist ${HOME}/.local/share/torbrowser

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

blacklist /opt
blacklist /srv

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.config/torbrowser
mkdir ${HOME}/.local/share/torbrowser
whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/torbrowser
whitelist ${HOME}/.local/share/torbrowser
whitelist /usr/share/torbrowser-launcher
include whitelist-common.inc
include whitelist-var-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc

# Uncomment the line below or put 'apparmor' in your torbrowser-launcher.local.
# IMPORTANT: the relevant rule in /etc/apparmor.d/local/firejail-default will need
# to be uncommented too for this to work as expected.
#apparmor
caps.drop all
netfilter
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
private-bin bash,cat,cp,cut,dirname,env,expr,file,gpg,grep,gxmessage,id,kdialog,ln,mkdir,mv,python*,rm,sed,sh,tail,tar,tclsh,test,tor-browser,tor-browser-en,torbrowser-launcher,update-desktop-database,xmessage,xz,zenity
private-dev
private-etc alsa,alternatives,asound.conf,ca-certificates,crypto-policies,fonts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,machine-id,pki,pulse,resolv.conf,ssl
private-tmp

dbus-user none
dbus-system none
