# Firejail profile for yt-dlp
# Description: Downloader of videos of various sites
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include yt-dlp.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.cache/yt-dlp
noblacklist ${HOME}/.config/yt-dlp
noblacklist ${HOME}/.config/yt-dlp.conf
noblacklist ${HOME}/yt-dlp.conf
noblacklist ${HOME}/yt-dlp.conf.txt

private-bin ffprobe,yt-dlp
private-etc alternatives,ld.so.cache,ld.so.preload,yt-dlp.conf

# Redirect
include youtube-dl.profile
