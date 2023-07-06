# Firejail profile for youtube-dl
# Description: Downloader of videos from YouTube and other sites
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include youtube-dl.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.cache/youtube-dl
noblacklist ${HOME}/.config/youtube-dl

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc

private-bin youtube-dl
private-etc youtube-dl.conf

# Redirect
include yt-dlp.profile
