# Mathematica profile
mkdir ~/.Mathematica
whitelist ~/.Mathematica
mkdir ~/.Wolfram Research
whitelist ~/.Wolfram Research
whitelist ~/Documents/Wolfram Mathematica
include /etc/firejail/whitelist-common.inc

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

caps.drop all
seccomp
noroot
