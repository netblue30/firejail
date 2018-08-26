# Firejail profile for firefox-developer-edition
# Description: Developer Edition of the popular Firefox web browser
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/firefox-developer-edition.local
# Persistent global definitions
include /etc/firejail/globals.local


# Redirect
include /etc/firejail/firefox.profile
