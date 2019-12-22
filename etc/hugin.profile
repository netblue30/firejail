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

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
net none
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none

private-bin align_image_stack,autooptimiser,calibrate_lens_gui,celeste_standalone,checkpto,cpclean,cpfind,deghosting_mask,enblend,fulla,geocpset,hugin,hugin_executor,hugin_hdrmerge,hugin_lensdb,hugin_stitch_project,icpfind,linefind,nona,pano_modify,pano_trafo,PTBatcherGUI,pto_gen,pto_lensstack,pto_mask,pto_merge,pto_move,pto_template,pto_var,tca_correct,verdandi,vig_optimize
private-cache
private-dev
#private-etc Trolltech.conf,X11,alternatives,bumblebee,dconf,drirc,fonts,gconf,glvnd,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,mime.types,pango,passwd,tor,xdg
private-tmp

