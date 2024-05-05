# Firejail profile for obsidian
# Description: Personal knowledge base and note-taking with Markdown files.
# This file is overwritten after every install/update
# Persistent local customizations
include obsidian.local
# Persistent global definitions
include globals.local

noblacklist ${DOCUMENTS}
noblacklist ${HOME}/.config/obsidian

ipc-namespace
nonewprivs
noroot
protocol unix,inet,inet6
#net none # networking is needed to download/update plugins

private-bin basename,bash,cat,cut,electron,electron[0-9],electron[0-9][0-9],gawk,grep,obsidian,realpath,tr
private-etc @network,@tls-ca,@x11,gnutls,libva.conf

# Redirect
include electron-common.profile
