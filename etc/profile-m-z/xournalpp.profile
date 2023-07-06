# Firejail profile for xournalpp
# Description: Handwriting note-taking software with PDF annotation support
# This file is overwritten after every install/update
# Persistent local customizations
include xournalpp.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.cache/xournalpp
noblacklist ${HOME}/.config/xournalpp
noblacklist ${HOME}/.xournalpp

include allow-lua.inc

whitelist /usr/share/texlive
whitelist /usr/share/xournalpp
whitelist /var/lib/texmf
include whitelist-runuser-common.inc

#mkdir ${HOME}/.cache/xournalpp
#mkdir ${HOME}/.config/xournalpp
#whitelist ${HOME}/.cache/xournalpp
#whitelist ${HOME}/.config/xournalpp
#whitelist ${HOME}/.xournalpp
#whitelist ${HOME}/.texlive20*
#whitelist ${DOCUMENTS}
#include whitelist-common.inc

private-bin kpsewhich,pdflatex,xournalpp
private-etc latexmk.conf,texlive

# Redirect
include xournal.profile
