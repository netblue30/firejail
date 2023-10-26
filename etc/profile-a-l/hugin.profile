# Firejail profile for hugin
# Description: Panorama photo stitcher
# This file is overwritten after every install/update
# Persistent local customizations
include hugin.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.hugin
noblacklist ${DOCUMENTS}
noblacklist ${PICTURES}

# Allow /bin/sh (blacklisted by disable-shell.inc)
include allow-bin-sh.inc

# Allow perl (blacklisted by disable-interpreters.inc)
include allow-perl.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

caps.drop all
net none
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp

private-bin PTBatcherGUI,align_image_stack,autooptimiser,calibrate_lens_gui,celeste_standalone,checkpto,cpclean,cpfind,deghosting_mask,enblend,exiftool,fulla,geocpset,hugin,hugin_executor,hugin_hdrmerge,hugin_lensdb,hugin_stitch_project,icpfind,linefind,nona,pano_modify,pano_trafo,perl,pto_gen,pto_lensstack,pto_mask,pto_merge,pto_move,pto_template,pto_var,sh,tca_correct,uname,verdandi,vig_optimize
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
