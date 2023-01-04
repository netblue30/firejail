# Firejail profile for sylpheed
# Description: Light weight e-mail client with GTK+
# This file is overwritten after every install/update
# Persistent local customizations
include sylpheed.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.sylpheed-2.0

mkdir ${HOME}/.sylpheed-2.0
whitelist ${HOME}/.sylpheed-2.0

whitelist /usr/share/sylpheed

# private-bin curl,gpg,gpg2,gpg-agent,gpgsm,pinentry,pinentry-gtk-2,sylpheed

dbus-user filter
dbus-user.talk ca.desrt.dconf
# Add the next line to your sylpheed.local to enable notifications.
# dbus-user.talk org.freedesktop.Notifications
dbus-user.talk org.freedesktop.secrets
dbus-user.talk org.gnome.keyring.SystemPrompter
dbus-user.talk org.mozilla.*

# Redirect
include email-common.profile
