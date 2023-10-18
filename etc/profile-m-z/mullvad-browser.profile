# Firejail profile for mullvad-browser
# Description: Privacy-focused web browser developed in a collaboration between Mullvad VPN and the Tor Project
# This file is overwritten after every install/update
# Persistent local customizations
include mullvad-browser.local
# Persistent global definitions
include globals.local

# IMPORTANT ##########################################
# The mullvad-browser can be downloaded from the official website
# and installed manually or via the AUR for Arch Linux (derivatives).
# The latter installs the browser under /opt/mullvad-browser, while
# the former can be installed under ${HOME} just about anywhere.
# If you decide to install it under ${HOME} this profile assumes to find
# the browser files under ${HOME}/.local/share/mullvad-browser.
# When you divert from that location you will need to make the needed
# path adjustments yourself in the below instructions.
####################################################

# If you installed under ${HOME}, put the below line in your
# mullvad-browser.local
# Note: The relevant rule in /etc/apparmor.d/local/firejail-default will
# need to be uncommented for the 'apparmor' option to work as expected.
#ignore noexec ${HOME}

noblacklist ${HOME}/.cache/mullvad/mullvadbrowser
noblacklist ${HOME}/.config/mullvad-browser-flags.conf
noblacklist ${HOME}/.local/share/mullvad-browser
noblacklist ${HOME}/.mullvad/mullvadbrowser

# Allow python 3 (blacklisted by disable-interpreters.inc)
include allow-python3.inc

blacklist /srv
blacklist /sys/class/net
blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/mullvad/mullvadbrowser
mkdir ${HOME}/.local/share/mullvad-browser
mkdir ${HOME}/.mullvad/mullvadbrowser
mkfile ${HOME}/.config/mullvad-browser-flags.conf
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/mullvad/mullvadbrowser
whitelist ${HOME}/.config/mullvad-browser-flags.conf
whitelist ${HOME}/.local/share/mullvad-browser
whitelist ${HOME}/.mullvad/mullvadbrowser
whitelist /opt/mullvad-browser
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
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
private-bin bash,cat,cp,cut,dirname,env,expr,file,gpg,grep,gxmessage,id,kdialog,ln,mkdir,mullvad-browser,mv,python*,rm,sed,sh,tail,tar,tclsh,test,update-desktop-database,xmessage,xz,zenity
private-dev
private-etc @tls-ca
private-tmp

blacklist ${PATH}/curl
blacklist ${PATH}/wget
blacklist ${PATH}/wget2

dbus-user filter
dbus-user.own org.mozilla.mullvadbrowser.*
dbus-system none

# cfr. start-mullvad-browser
# do not (try to) connect to the session manager
rmenv SESSION_MANAGER

#restrict-namespaces
