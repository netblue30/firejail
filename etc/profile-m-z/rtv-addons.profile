# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include rtv-addons.local
# You can configure rtv to open different type of links
# in external applications. Configuration here:
# https://github.com/michael-lazar/rtv#viewing-media-links
# This include is meant to facilitate that configuration
# with the use of a .local file.

ignore nosound
ignore private-bin
ignore dbus-user none

noblacklist ${HOME}/.cache/mpv
noblacklist ${HOME}/.config/mpv
noblacklist ${HOME}/.local/state/mpv
noblacklist ${HOME}/.mailcap
noblacklist ${HOME}/.netrc
noblacklist ${HOME}/.w3m

whitelist ${HOME}/.cache/mpv
whitelist ${HOME}/.cache/youtube-dl/youtube-sigfuncs
whitelist ${HOME}/.config/mpv
whitelist ${HOME}/.local/state/mpv
whitelist ${HOME}/.mailcap
whitelist ${HOME}/.netrc
whitelist ${HOME}/.w3m

#private-bin w3m,mpv,youtube-dl

# tells rtv, which browser to use
#env RTV_BROWSER=w3m
