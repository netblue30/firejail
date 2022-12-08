# Firejail profile for tesseract
# Description: An OCR program
# This file is overwritten after every install/update
# Persistent local customizations
include tesseract.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

whitelist ${DOCUMENTS}
whitelist ${DOWNLOADS}
whitelist ${PICTURES}
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
whitelist /usr/share/tessdata
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
hostname tesseract
ipc-namespace
machine-id
net none
no3d
nodvd
nogroups
noinput
nonewprivs
noprinters
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
tracelog
x11 none

#disable-mnt
private-bin ambiguous_words,classifier_tester,cntraining,combine_lang_model,combine_tessdata,dawg2wordlist,lstmeval,lstmtraining,merge_unicharsets,mftraining,set_unicharset_properties,shapeclustering,tesseract,text2image,unicharset_extractor,wordlist2dawg
private-cache
private-dev
private-etc fonts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload
#private-lib libtesseract.so.*
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
