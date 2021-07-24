# Firejail profile for xournalpp
# Description: Handwriting note-taking software with PDF annotation support
# This file is overwritten after every install/update
# Persistent local customizations
include xournalpp.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.xournalpp

include allow-lua.inc

allow  /usr/share/texlive
allow  /usr/share/xournalpp
allow  /var/lib/texmf
include whitelist-runuser-common.inc

#mkdir ${HOME}/.xournalpp
#whitelist ${HOME}/.xournalpp
#whitelist ${HOME}/.texlive20*
#whitelist ${DOCUMENTS}
#include whitelist-common.inc

private-bin kpsewhich,pdflatex,xournalpp
private-etc latexmk.conf,texlive

# Redirect
include xournal.profile
