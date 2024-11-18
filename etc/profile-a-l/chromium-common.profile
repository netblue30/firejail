# Firejail profile for chromium-common
# This file is overwritten after every install/update
# Persistent local customizations
include chromium-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

# noexec ${HOME} breaks DRM binaries.
?BROWSER_ALLOW_DRM: ignore noexec ${HOME}

# To enable support for the KeePassXC extension, add the following lines to
# chromium-common.local.
# Note: Start KeePassXC before the web browser and keep it open to allow
# communication between them.
#noblacklist ${RUNUSER}/app
#whitelist ${RUNUSER}/app/org.keepassxc.KeePassXC
#whitelist ${RUNUSER}/kpxc_server
#whitelist ${RUNUSER}/org.keepassxc.KeePassXC.BrowserServer

noblacklist ${HOME}/.local/share/pki
noblacklist ${HOME}/.pki
noblacklist /usr/lib/chromium/chrome-sandbox

# Add the next line to chromium-common.local if you want the web browser to
# have access to Gnome extensions (extensions.gnome.org) via the browser
# connector.
#include allow-python3.inc

blacklist ${PATH}/curl
blacklist ${PATH}/wget
blacklist ${PATH}/wget2

mkdir ${HOME}/.local/share/pki
mkdir ${HOME}/.pki
whitelist ${HOME}/.local/share/pki
whitelist ${HOME}/.pki
whitelist /usr/share/mozilla/extensions
whitelist /usr/share/webext
include whitelist-run-common.inc

# If your kernel allows the creation of user namespaces by unprivileged users
# (for example, if running `unshare -U echo enabled` prints "enabled"), you
# can add the next line to chromium-common.local.
#include chromium-common-hardened.inc.profile

?BROWSER_DISABLE_U2F: nou2f

?BROWSER_DISABLE_U2F: private-dev
#private-tmp # issues when using multiple browser sessions

# Note: This prevents access to passwords saved in GNOME Keyring and KWallet
# and breaks Gnome connector.
#dbus-user none

# The file dialog needs to work without d-bus.
?HAS_NODBUS: env NO_CHROME_KDE_FILE_DIALOG=1

# Redirect
include blink-common.profile
