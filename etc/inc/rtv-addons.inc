# This file is overwritten during software install.
# Persistent customizations should go in a .local file.

# You can configure rtv to open different type of links
# in external applications. Configuration here:
# https://github.com/michael-lazar/rtv#viewing-media-links
# This include is meant to facilitate that configuration
# with the use of a .local file.

ignore nosound
ignore private-bin
ignore dbus-user none

noblacklist ${HOME}/.cache/youtube-dl/youtube-sigfuncs
noblacklist ${HOME}/.config/mpv
noblacklist ${HOME}/.mailcap
noblacklist ${HOME}/.netrc
noblacklist ${HOME}/.w3m

whitelist ${HOME}/.cache/youtube-dl/youtube-sigfuncs
whitelist ${HOME}/.config/mpv
whitelist ${HOME}/.mailcap
whitelist ${HOME}/.netrc
whitelist ${HOME}/.w3m
