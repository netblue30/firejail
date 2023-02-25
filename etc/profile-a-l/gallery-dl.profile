# Firejail profile for gallery-dl
# Description: Downloader of images from various sites
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include gallery-dl.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.config/gallery-dl
noblacklist ${HOME}/.gallery-dl.conf

private-bin gallery-dl
private-etc gallery-dl.conf

# Redirect
include youtube-dl.profile
