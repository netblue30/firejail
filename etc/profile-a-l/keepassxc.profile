# Firejail profile for keepassxc
# Description: Cross Platform Password Manager
# This file is overwritten after every install/update
# Persistent local customizations
include keepassxc.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/*.kdb
nodeny  ${HOME}/*.kdbx
nodeny  ${HOME}/.cache/keepassxc
nodeny  ${HOME}/.config/keepassxc
nodeny  ${HOME}/.config/KeePassXCrc
nodeny  ${HOME}/.keepassxc
nodeny  ${DOCUMENTS}

# Allow browser profiles, required for browser integration.
nodeny  ${HOME}/.config/BraveSoftware
nodeny  ${HOME}/.config/chromium
nodeny  ${HOME}/.config/google-chrome
nodeny  ${HOME}/.config/vivaldi
nodeny  ${HOME}/.local/share/torbrowser
nodeny  ${HOME}/.mozilla

deny  /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

# You can enable whitelisting for keepassxc by adding the below to your keepassxc.local.
# If you do, you MUST store your database under ${HOME}/Documents/KeePassXC/foo.kdbx.
#mkdir ${HOME}/Documents/KeePassXC
#whitelist ${HOME}/Documents/KeePassXC
# Needed for KeePassXC-Browser.
#mkfile ${HOME}/.config/BraveSoftware/Brave-Browser/NativeMessagingHosts/org.keepassxc.keepassxc_browser.json
#whitelist ${HOME}/.config/BraveSoftware/Brave-Browser/NativeMessagingHosts/org.keepassxc.keepassxc_browser.json
#mkfile ${HOME}/.config/chromium/NativeMessagingHosts/org.keepassxc.keepassxc_browser.json
#whitelist ${HOME}/.config/chromium/NativeMessagingHosts/org.keepassxc.keepassxc_browser.json
#mkfile ${HOME}/.config/google-chrome/NativeMessagingHosts/org.keepassxc.keepassxc_browser.json
#whitelist ${HOME}/.config/google-chrome/NativeMessagingHosts/org.keepassxc.keepassxc_browser.json
#mkfile ${HOME}/.config/vivaldi/NativeMessagingHosts/org.keepassxc.keepassxc_browser.json
#whitelist ${HOME}/.config/vivaldi/NativeMessagingHosts/org.keepassxc.keepassxc_browser.json
#mkfile ${HOME}/.local/share/torbrowser/tbb/x86_64/tor-browser_en-US/Browser/TorBrowser/Data/Browser/.mozilla/native-messaging-hosts/org.keepassxc.keepassxc_browser.json
#whitelist ${HOME}/.local/share/torbrowser/tbb/x86_64/tor-browser_en-US/Browser/TorBrowser/Data/Browser/.mozilla/native-messaging-hosts/org.keepassxc.keepassxc_browser.json
#mkfile ${HOME}/.mozilla/native-messaging-hosts/org.keepassxc.keepassxc_browser.json
#whitelist ${HOME}/.mozilla/native-messaging-hosts/org.keepassxc.keepassxc_browser.json
#mkdir ${HOME}/.cache/keepassxc
#mkdir ${HOME}/.config/keepassxc
#whitelist ${HOME}/.cache/keepassxc
#whitelist ${HOME}/.config/keepassxc
#whitelist ${HOME}/.config/KeePassXCrc
#include whitelist-common.inc

allow  /usr/share/keepassxc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
machine-id
net none
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,netlink
seccomp !name_to_handle_at
seccomp.block-secondary
shell none
tracelog

private-bin keepassxc,keepassxc-cli,keepassxc-proxy
private-dev
private-etc alternatives,fonts,ld.so.cache,machine-id
private-tmp

dbus-user filter
#dbus-user.own org.keepassxc.KeePassXC
dbus-user.talk com.canonical.Unity.Session
dbus-user.talk org.freedesktop.ScreenSaver
dbus-user.talk org.freedesktop.login1.Manager
dbus-user.talk org.freedesktop.login1.Session
dbus-user.talk org.gnome.ScreenSaver
dbus-user.talk org.gnome.SessionManager
dbus-user.talk org.gnome.SessionManager.Presence
# Add the next line to your keepassxc.local to allow notifications.
#dbus-user.talk org.freedesktop.Notifications
# Add the next line to your keepassxc.local to allow the tray menu.
#dbus-user.talk org.kde.StatusNotifierWatcher
#dbus-user.own org.kde.*
dbus-system none

# Mutex is stored in /tmp by default, which is broken by private-tmp.
join-or-start keepassxc
