# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/geray.local

# Firejail profile for Gnome Geary
# Users have Geary set to open a browser by clicking a link in an email
# We are not allowed to blacklist browser-specific directories

noblacklist ~/.gnupg
mkdir ~/.gnupg
whitelist ~/.gnupg

noblacklist ~/.local/share/geary
mkdir ~/.local/share/geary
whitelist ~/.local/share/geary

whitelist ~/.config/mimeapps.list
read-only ~/.config/mimeapps.list
whitelist ~/.local/share/applications
read-only ~/.local/share/applications

# allow browsers
ignore private-tmp
include /etc/firejail/firefox.profile
#include /etc/firejail/chromium.profile - chromium runs as suid!
