# Firejail profile for yt-dlp
# Description: Downloader of videos of various sites
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include yt-dlp.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/yt-dlp
noblacklist ${HOME}/.config/yt-dlp
noblacklist ${HOME}/yt-dlp.conf

private-bin yt-dlp
private-etc yt-dlp.conf

# Redirect
include youtube-dl.profile
