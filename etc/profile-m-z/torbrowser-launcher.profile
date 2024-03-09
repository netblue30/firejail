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

blacklist /srv
blacklist /sys/class/net

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.config/torbrowser
mkdir ${HOME}/.local/share/torbrowser
whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/torbrowser
whitelist ${HOME}/.local/share/torbrowser
whitelist /opt/tor-browser
whitelist /usr/share/torbrowser-launcher
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

# Add 'apparmor' to your torbrowser-launcher.local to enable AppArmor support.
# IMPORTANT: the relevant rule in /etc/apparmor.d/local/firejail-default will need
# to be uncommented too for this to work as expected.
#apparmor
caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp !chroot
seccomp.block-secondary
#tracelog # may cause issues, see #1930

disable-mnt
private-bin bash,cat,cp,cut,dirname,env,execdesktop,expr,file,gpg,grep,gxmessage,id,kdialog,ln,mkdir,mv,python*,rm,sed,sh,tail,tar,tclsh,test,tor-browser,tor-browser-en,torbrowser-launcher,update-desktop-database,xmessage,xz,zenity
private-dev
private-etc @tls-ca
private-tmp

dbus-user none
dbus-system none

#restrict-namespaces
