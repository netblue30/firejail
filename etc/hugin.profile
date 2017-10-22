# Firejail profile for hugin
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/hugin.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /run/user/*/bus

noblacklist ${HOME}/.hugin

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
net none
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
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
