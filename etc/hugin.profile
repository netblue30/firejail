# Firejail profile for hugin
# Description: Panorama photo stitcher
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/hugin.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.hugin
noblacklist ${DOCUMENTS}
noblacklist ${PICTURES}

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

caps.drop all
net none
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none

private-bin PTBatcherGUI,calibrate_lens_gui,hugin,hugin_stitch_project,align_image_stack,autooptimiser,celeste_standalone,checkpto,cpclean,cpfind,deghosting_mask,fulla,geocpset,hugin_executor,hugin_hdrmerge,hugin_lensdb,icpfind,linefind,nona,pano_modify,pano_trafo,pto_gen,pto_lensstack,pto_mask,pto_merge,pto_move,pto_template,pto_var,tca_correct,verdandi,vig_optimize,enblend
private-cache
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
