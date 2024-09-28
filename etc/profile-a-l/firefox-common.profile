# Firejail profile for firefox-common
# This file is overwritten after every install/update
# Persistent local customizations
include firefox-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

# noexec ${HOME} breaks DRM binaries.
?BROWSER_ALLOW_DRM: ignore noexec ${HOME}
# noexec ${RUNUSER} breaks DRM binaries when using profile-sync-daemon.
?BROWSER_ALLOW_DRM: ignore noexec ${RUNUSER}

# Add the next lines to firefox-common.local if you want to use the migration
# wizard.
#noblacklist ${HOME}/.mozilla
#whitelist ${HOME}/.mozilla

# To enable support for the KeePassXC extension, add the following lines to
# firefox-common.local.
# Note: Start KeePassXC before the web browser and keep it open to allow
# communication between them.
#noblacklist ${RUNUSER}/app
#whitelist ${RUNUSER}/app/org.keepassxc.KeePassXC
#whitelist ${RUNUSER}/kpxc_server
#whitelist ${RUNUSER}/org.keepassxc.KeePassXC.BrowserServer

# Add the next line to firefox-common.local to allow access to common
# programs/addons/plugins.
#include firefox-common-addons.profile

noblacklist ${HOME}/.local/share/pki
noblacklist ${HOME}/.pki

blacklist ${PATH}/curl
blacklist ${PATH}/wget
blacklist ${PATH}/wget2

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc

mkdir ${HOME}/.local/share/pki
mkdir ${HOME}/.pki
whitelist ${DOWNLOADS}
whitelist ${HOME}/.local/share/pki
whitelist ${HOME}/.pki
whitelist /usr/share/doc
whitelist /usr/share/gtk-doc/html
whitelist /usr/share/mozilla
whitelist /usr/share/webext
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
# Fixme!
apparmor-replace
caps.drop all
# Note: machine-id breaks pulseaudio; add it to firefox-common.local if sound
# is not required.
#machine-id
netfilter
nodvd
nogroups
noinput
nonewprivs
# Note: noroot breaks GTK_USE_PORTAL=1 usage; see
# https://github.com/netblue30/firejail/issues/2506.
noroot
notv
?BROWSER_DISABLE_U2F: nou2f
protocol unix,inet,inet6,netlink
# Note: The seccomp line below still permits the chroot syscall; see
# https://github.com/netblue30/firejail/issues/2506 for possible workarounds.
seccomp !chroot
# Note: tracelog may break or cause major issues with many Firefox-based
# browsers; see https://github.com/netblue30/firejail/issues/1930.
#tracelog

disable-mnt
?BROWSER_DISABLE_U2F: private-dev
# Note: The private-etc line below works fine on most distributions but it
# could cause problems on CentOS.
private-etc @tls-ca,@x11,mailcap,mime.types,os-release
private-tmp

# Note: `dbus-user none` breaks various desktop integration features like
# global menus, native notifications, Gnome connector, KDE Connect and power
# management on KDE Plasma.
dbus-user none
dbus-system none

# Add the next line to firefox-common.local to enable native notifications.
#dbus-user.talk org.freedesktop.Notifications
# Add the next line to firefox-common.local to allow inhibiting screensavers.
#dbus-user.talk org.freedesktop.ScreenSaver
# Add the next lines to firefox-common.local for plasma browser integration.
#dbus-user.own org.mpris.MediaPlayer2.plasma-browser-integration
#dbus-user.talk org.kde.JobViewServer
#dbus-user.talk org.kde.kdeconnect
#dbus-user.talk org.kde.kuiserver
# Add the next line to firefox-common.local to allow screensharing under
# Wayland.
#dbus-user.talk org.freedesktop.portal.Desktop
# Also add the next line to firefox-common.local if screensharing does not work
# with the above lines (depends on the portal implementation).
#ignore noroot

#restrict-namespaces
