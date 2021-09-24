# Firejail profile for mupdf-x11-curl
# Description: Lightweight PDF viewer
# This file is overwritten after every install/update
# Persistent local customizations
include mupdf-x11-curl.local
# Persistent global definitions
# added by included profile
#include globals.local

ignore net none

netfilter
protocol unix,inet,inet6

private-etc ca-certificates,crypto-policies,hosts,ld.so.preload,nsswitch.conf,pki,resolv.conf,ssl

# Redirect
include mupdf.profile
