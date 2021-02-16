#!/bin/bash

# This file is part of Firejail project
# Copyright (C) 2020-2021 Firejail Authors
# License GPL v2

if ! command -v zenity >/dev/null; then
	echo "Please install zenity."
	exit 1
fi
if ! command -v sudo >/dev/null; then
	echo "Please install sudo."
	exit 1
fi

export LANG=en_US.UTF8

zenity --title=firejail-welcome.sh --text-info --width=750 --height=500 <<EOM
Welcome to firejail!

This is a quick setup guide for newbies.

Profiles for programs can be found in /etc/firejail. Own customizations should go in a file named
<profile-name>.local in ~/.config/firejal.

Firejail's own configuration can be found at /etc/firejail/firejail.config.

Please note that running this script a second time can set new options, but does not unset options
set in a previous run.

Website: https://firejail.wordpress.com
Bug-Tracker: https://github.com/netblue30/firejail/issues
Documentation:
- https://github.com/netblue30/firejail/wiki
- https://github.com/netblue30/firejail/wiki/Frequently-Asked-Questions
- https://firejail.wordpress.com/documentation-2
- man:firejail(1) and man:firejail-profile(5)

PS: If you have any improvements for this script, open an issue or pull request.
EOM
[[ $? -eq 1 ]] && exit 0

sed_scripts=()

read -r -d $'\0' MSG_Q_BROWSER_DISABLE_U2F <<EOM
<big><b>Should browsers be allowed to access u2f hardware?</b></big>
EOM

read -r -d $'\0' MSG_Q_BROWSER_ALLOW_DRM <<EOM
<big><b>Should browsers be able to play DRM content?</b></big>

\$HOME is noexec,nodev,nosuid by default for the most sandboxes. This means that executing programs which are located in \$HOME,
is forbidden, the setuid attribute on files is ignored and device files inside \$HOME don't work. Browsers install proprietary
DRM plug-ins such as Widevine under \$HOME by default. In order to use them, \$HOME must be mounted exec inside the sandbox to
allow their execution. Clearly, this may help an attacker to start malicious code.

NOTE: Other software written in an interpreter language such as bash, python or java can always be started from \$HOME.

HINT: If <tt>/home</tt> has its own partition, you can mount it <tt>nodev,nosuid</tt> for all programs.
EOM

read -r -d $'\0' MSG_L_ADVANCED_OPTIONS <<EOM
You maybe want to set some of these advanced options.
EOM

read -r -d $'\0' MSG_Q_RUN_FIRECFG <<EOM
<big><b>Should most programs be started in firejail by default?</b></big>
EOM

read -r -d $'\0' MSG_I_ROOT_REQUIRED <<EOM
In order to apply these changes, root privileges are required.
You will now be asked to enter your password.
EOM

read -r -d $'\0' MSG_I_FINISH <<EOM
🥳
EOM

if zenity --title=firejail-welcome.sh --question --ellipsize --text="$MSG_Q_BROWSER_DISABLE_U2F"; then
	sed_scripts+=("-e s/# browser-disable-u2f yes/browser-disable-u2f no/")
fi

if zenity --title=firejail-welcome.sh --question --ellipsize --text="$MSG_Q_BROWSER_ALLOW_DRM"; then
	sed_scripts+=("-e s/# browser-allow-drm no/browser-allow-drm yes/")
fi

advanced_options=$(zenity --title=firejail-welcome.sh --list --width=800 --height=200 \
	--text="$MSG_L_ADVANCED_OPTIONS" --multiple --checklist --separator=" " \
	--column="" --column=Option --column=Description <<EOM

force-nonewprivs
Always set nonewprivs, this is a strong mitigation against exploits in firejail. However some programs like chromium or wireshark maybe don't work anymore.

restricted-network
Restrict all network related commands except 'net none' to root only.

seccomp-error-action=kill
Kill programs which violate seccomp rules (default: return a error).
EOM
)

if [[ $advanced_options == *force-nonewprivs* ]]; then
	sed_scripts+=("-e s/# force-nonewprivs no/force-nonewprivs yes/")
fi
if [[ $advanced_options == *restricted-network* ]]; then
	sed_scripts+=("-e s/# restricted-network no/restricted-network yes/")
fi
if [[ $advanced_options == *seccomp-error-action=kill* ]]; then
	sed_scripts+=("-e s/# seccomp-error-action EPERM/seccomp-error-action kill/")
fi

if zenity --title=firejail-welcome.sh --question --ellipsize --text="$MSG_Q_RUN_FIRECFG"; then
	run_firecfg=true
fi

zenity --title=firejail-welcome.sh --info --ellipsize --text="$MSG_I_ROOT_REQUIRED"

passwd=$(zenity --title=firejail-welcome.sh --password --cancel-label=OK)
if [[ -n "${sed_scripts[*]}" ]]; then
	sudo -S -p "" -- sed -i "${sed_scripts[@]}" /etc/firejail/firejail.config <<<"$passwd" || { zenity --title=firejail-welcome.sh --error; exit 1; };
fi
if [[ "$run_firecfg" == "true" ]]; then
	sudo -S -p "" -- firecfg <<<"$passwd" || { zenity --title=firejail-welcome.sh --error; exit 1; };
fi
sudo -k
unset passwd

zenity --title=firejail-welcome.sh --info --icon-name=security-medium-symbolic --text="$MSG_I_FINISH"
