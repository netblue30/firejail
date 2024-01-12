#!/bin/bash

# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2
#
# Usage: firejail-welcome PROGRAM SYSCONFDIR USER_NAME
# where PROGRAM is detected and driven by firecfg.
# SYSCONFDIR is most of the time /etc/firejail.
#
# The plan is to go with zenity by default. If zenity is not installed
# we will provide a console-only replacement in /usr/lib/firejail/fzenity
#

if ! command -v "$1" >/dev/null; then
	echo "Please install $1."
	exit 1
fi

PROGRAM="sudo -u $3 $1"
SYSCONFDIR=$2
export LANG=en_US.UTF8

TITLE="Firejail Configuration Guide"
sed_scripts=()
run_firecfg=false
enable_u2f=false
enable_drm=false
enable_seccomp_kill=false
enable_restricted_net=false
enable_nonewprivs=false

#******************************************************
# Intro
#******************************************************
read -r -d $'\0' MSG_INTRO <<EOM
<big><b>Welcome to Firejail!</b></big>

This guide will walk you through some of the most common sandbox customizations.
At the end of the guide you'll have the option to save your changes in Firejail's
global config file at <b>/etc/firejail/firejail.config</b>. A copy of the original file is saved
as <b>/etc/firejal/firejail.config-</b>.

Please note that running this script a second time can set new options, but does
not clear options set in a previous run.

Press OK to continue, or close this window to stop the program.

EOM
$PROGRAM --title="$TITLE" --info --width=600 --height=40 --text="$MSG_INTRO"
[[ $? -eq 1 ]] && exit 0

#******************************************************
# symlinks
#******************************************************
read -r -d $'\0' MSG_Q_RUN_FIRECFG <<EOM
<big><b>Should most programs be sandboxed by default?</b></big>

Currently, Firejail recognizes more than 1000 regular desktop programs. These programs
can be sandboxed automatically when you start them.

EOM

if $PROGRAM --title="$TITLE" --question --ellipsize --text="$MSG_Q_RUN_FIRECFG"; then
	run_firecfg=true
fi

#******************************************************
# U2F
#******************************************************
read -r -d $'\0' MSG_Q_BROWSER_DISABLE_U2F <<EOM
<big><b>Should browsers be allowed to access u2f hardware?</b></big>

Universal Two-Factor (U2F) devices are used as a password store for online
accounts. These devices usually come in a form of a USB key.

EOM

if $PROGRAM --title="$TITLE" --question --ellipsize --text="$MSG_Q_BROWSER_DISABLE_U2F"; then
	enable_u2f=true
	sed_scripts+=("-e s/# browser-disable-u2f yes/browser-disable-u2f no/")
fi

#******************************************************
# DRM
#******************************************************
read -r -d $'\0' MSG_Q_BROWSER_ALLOW_DRM <<EOM
<big><b>Should browsers be able to play DRM content?</b></big>

The home directory is <tt>noexec,nodev,nosuid</tt> by default for most applications.
This means that executing programs located in your home directory is forbidden.

Browsers install proprietary DRM plug-ins such as Widevine in your home directory.
In order to use them, your home must be mounted <tt>exec</tt> inside the sandbox. This
may give the people developing and distributing the plug-in access to your private
data.

NOTE: Software written in an interpreted language such as bash, python or java can
always be started from home directory.

HINT: If <tt>/home</tt> has its own partition, you can mount it <tt>nodev,nosuid</tt> for all programs.

EOM

if $PROGRAM --title="$TITLE" --question --ellipsize --text="$MSG_Q_BROWSER_ALLOW_DRM"; then
	enable_drm=true
	sed_scripts+=("-e s/# browser-allow-drm no/browser-allow-drm yes/")
fi

#******************************************************
# nonewprivs
#******************************************************
read -r -d $'\0' MSG_Q_NONEWPRIVS <<EOM
<big><b>Should we force nonewprivs by default?</b></big>

nonewprivs is a Linux kernel feature that prevents programs from rising privileges.
It is also a strong mitigation against exploits in Firejail. However, some programs
like chromium, wireshark, or even ping might not work.

NOTE: seccomp enables nonewprivs automatically. Most applications supported by
default by Firejail are using seccomp.

EOM

if $PROGRAM --title="$TITLE" --question --ellipsize --text="$MSG_Q_NONEWPRIVS"; then
	enable_nonewprivs=true
	sed_scripts+=("-e s/# force-nonewprivs no/force-nonewprivs yes/")
fi

#******************************************************
# restricted network
#******************************************************
read -r -d $'\0' MSG_Q_NETWORK <<EOM
<big><b>Should we restrict network functionality?</b></big>

Restrict all network related commands except '<tt>net none</tt>' to root only.

EOM

if $PROGRAM --title="$TITLE" --question --ellipsize --text="$MSG_Q_NETWORK"; then
	enable_restricted_net=true
	sed_scripts+=("-e s/# restricted-network no/restricted-network yes/")
fi

#******************************************************
# seccomp kill
#******************************************************
read -r -d $'\0' MSG_Q_SECCOMP <<EOM
<big><b>Should we kill programs that violate seccomp rules?</b></big>

By default seccomp prevents the program from running the syscall and returns an error.

EOM

if $PROGRAM --title="$TITLE" --question --ellipsize --text="$MSG_Q_SECCOMP"; then
	enable_seccomp_kill=true
	sed_scripts+=("-e s/# seccomp-error-action EPERM/seccomp-error-action kill/")
fi

#******************************************************
# root
#******************************************************
read -r -d $'\0' MSG_RUN <<EOM
Now, I will apply the changes. This is what I will do:


EOM
MSG_RUN+="\n\n"
if [[ "$run_firecfg" == "true" ]]; then
	MSG_RUN+="     * enable Firejail for all recognized programs\n"
fi
if [[ "$enable_u2f" == "true" ]]; then
	MSG_RUN+="     * allow browsers to access U2F devices\n"
fi
if [[ "$enable_drm" == "true" ]]; then
	MSG_RUN+="     * allow browsers to play DRM content\n"
fi
if [[ "$enable_nonewprivs" == "true" ]]; then
	MSG_RUN+="     * enable nonewprivs globally\n"
fi
if [[ "$enable_restricted_net" == "true" ]]; then
	MSG_RUN+="     * restrict networking features\n"
fi
if [[ "$enable_seccomp_kill" == "true" ]]; then
	MSG_RUN+="     * enable seccomp kill\n"
fi
MSG_RUN+="\n\nPress OK to continue, or close this window to stop the program."

$PROGRAM --title="$TITLE" --info --width=600 --height=40 --text="$MSG_RUN"
[[ $? -eq 1 ]] && exit 0

if [[ -n "${sed_scripts[*]}" ]]; then
	cp "$SYSCONFDIR"/firejail.config "$SYSCONFDIR"/firejail.config-
	sed -i "${sed_scripts[@]}" "$SYSCONFDIR"/firejail.config
fi
if [[ "$run_firecfg" == "true" ]]; then
	# return 55 to inform firecfg symlinks are desired
	exit 55
fi

#******************************************************
# all done
#******************************************************
exit 0
