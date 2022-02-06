# Firejail profile for keepassxc
# Description: Cross Platform Password Manager
# This file is overwritten after every install/update
# Persistent local customizations
include keepassxc.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/*.kdb
noblacklist ${HOME}/*.kdbx
noblacklist ${HOME}/.cache/keepassxc
noblacklist ${HOME}/.config/keepassxc
noblacklist ${HOME}/.config/KeePassXCrc
noblacklist ${HOME}/.keepassxc
noblacklist ${DOCUMENTS}

# Allow browser profiles, required for browser integration.
noblacklist ${HOME}/.config/BraveSoftware
noblacklist ${HOME}/.config/chromium
noblacklist ${HOME}/.config/google-chrome
noblacklist ${HOME}/.config/vivaldi
noblacklist ${HOME}/.local/share/torbrowser
noblacklist ${HOME}/.mozilla

blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

# You can enable whitelisting for keepassxc by adding the below to your keepassxc.local.
# If you do, you MUST store your database under ${HOME}/Documents/KeePassXC/foo.kdbx.
#mkdir ${HOME}/Documents/KeePassXC
#whitelist ${HOME}/Documents/KeePassXC
# Needed for KeePassXC-Browser.
#mkdir ${HOME}/.config/BraveSoftware/Brave-Browser/NativeMessagingHosts
#mkfile ${HOME}/.config/BraveSoftware/Brave-Browser/NativeMessagingHosts/org.keepassxc.keepassxc_browser.json
#whitelist ${HOME}/.config/BraveSoftware/Brave-Browser/NativeMessagingHosts/org.keepassxc.keepassxc_browser.json
#mkdir ${HOME}/.config/chromium/NativeMessagingHosts
#mkfile ${HOME}/.config/chromium/NativeMessagingHosts/org.keepassxc.keepassxc_browser.json
#whitelist ${HOME}/.config/chromium/NativeMessagingHosts/org.keepassxc.keepassxc_browser.json
#mkdir ${HOME}/.config/google-chrome/NativeMessagingHosts
#mkfile ${HOME}/.config/google-chrome/NativeMessagingHosts/org.keepassxc.keepassxc_browser.json
#whitelist ${HOME}/.config/google-chrome/NativeMessagingHosts/org.keepassxc.keepassxc_browser.json
#mkdir ${HOME}/.config/vivaldi/NativeMessagingHosts
#mkfile ${HOME}/.config/vivaldi/NativeMessagingHosts/org.keepassxc.keepassxc_browser.json
#whitelist ${HOME}/.config/vivaldi/NativeMessagingHosts/org.keepassxc.keepassxc_browser.json
#mkdir ${HOME}/.local/share/torbrowser/tbb/x86_64/tor-browser_en-US/Browser/TorBrowser/Data/Browser/.mozilla/native-messaging-hosts
#mkfile ${HOME}/.local/share/torbrowser/tbb/x86_64/tor-browser_en-US/Browser/TorBrowser/Data/Browser/.mozilla/native-messaging-hosts/org.keepassxc.keepassxc_browser.json
#whitelist ${HOME}/.local/share/torbrowser/tbb/x86_64/tor-browser_en-US/Browser/TorBrowser/Data/Browser/.mozilla/native-messaging-hosts/org.keepassxc.keepassxc_browser.json
#mkdir ${HOME}/.mozilla/native-messaging-hosts
#mkfile ${HOME}/.mozilla/native-messaging-hosts/org.keepassxc.keepassxc_browser.json
#whitelist ${HOME}/.mozilla/native-messaging-hosts/org.keepassxc.keepassxc_browser.json
#mkdir ${HOME}/.cache/keepassxc
#mkdir ${HOME}/.config/keepassxc
#whitelist ${HOME}/.cache/keepassxc
#whitelist ${HOME}/.config/keepassxc
#whitelist ${HOME}/.config/KeePassXCrc
#include whitelist-common.inc

whitelist /usr/share/keepassxc
include whitelist-run-common.inc
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
novideo
protocol unix
seccomp !name_to_handle_at
seccomp.block-secondary
shell none
tracelog

private-bin keepassxc,keepassxc-cli,keepassxc-proxy
# Note: private-dev prevents the program from seeing new devices (such as
# hardware keys) on /dev after it has already started; add "ignore private-dev"
# to keepassxc.local if this is an issue (see #4883).
private-dev
private-etc alternatives,fonts,ld.so.cache,ld.so.preload,machine-id
private-tmp

dbus-user filter
dbus-user.own org.keepassxc.KeePassXC.*
dbus-user.talk com.canonical.Unity
dbus-user.talk org.freedesktop.ScreenSaver
dbus-user.talk org.gnome.ScreenSaver
dbus-user.talk org.gnome.SessionManager
dbus-user.talk org.xfce.ScreenSaver
?ALLOW_TRAY: dbus-user.talk org.kde.StatusNotifierWatcher
?ALLOW_TRAY: dbus-user.own org.kde.*
# Add the next line to your keepassxc.local to allow notifications.
#dbus-user.talk org.freedesktop.Notifications
dbus-system filter
dbus-system.talk org.freedesktop.login1

# Mutex is stored in /tmp by default, which is broken by private-tmp.
join-or-start keepassxc
