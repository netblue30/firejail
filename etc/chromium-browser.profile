# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/chromium-browser.local

# Chromium browser profile
include /etc/firejail/chromium.profile
