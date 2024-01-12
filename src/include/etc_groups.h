/*
 * Copyright (C) 2014-2024 Firejail Authors
 *
 * This file is part of firejail project
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/

#ifndef ETC_GROUPS_H
#define ETC_GROUPS_H
#include <stddef.h>

#define ETC_MAX 256

// @default
static char *etc_list[ETC_MAX + 1] = { // plus 1 for ending NULL pointer
	"alternatives",
	"fonts",
	"gcrypt", 	// GNU crypto library - it contains configuration for specialized encryption
		// and random number generators hardware.
		// The directory is not installed in Debian. On Fedora it is an empty directory.
		// The defaults in glibc cover the regular PC.
	"group",
	"ld.so.cache",
	"ld.so.conf",
	"ld.so.conf.d",
	"ld.so.preload",
	"locale",
	"locale.alias",
	"locale.conf",
	"localtime",
	"login.defs", // firejail reading UID/GID MIN and MAX at startup
	"nsswitch.conf",
	"passwd",
	"selinux",
	NULL
};

// @games
static char *etc_group_games[] = {
	"openal", // 3D sound
	"timidity", // MIDI
	"timidity.cfg",
	NULL
};

// @network
static char*etc_group_network[] = {
	"hostname",
	"hosts",
	"protocols",
	"resolv.conf",
	NULL
};

// @sound
static char *etc_group_sound[] = {
	"alsa",
	"asound.conf",
	"machine-id", // required by PulseAudio
	"pulse",
	NULL
};

// @tls-ca
static char *etc_group_tls_ca[] = {
	"ca-certificates",
	"crypto-policies",
	"pki",
	"ssl",
	NULL
};

// @x11
static char *etc_group_x11[] = {
	"ati", // 3D
	"dconf",
	"drirc",
	"gtk-2.0",
	"gtk-3.0",
	"kde4rc",
	"kde5rc",
	"machine-id", // QT dbus lib is crashing without it!
	"nvidia", // 3D
	"pango", // text rendering/internationalization
	"Trolltech.conf", // old QT config file
	"vulkan", // next generation OpenGL stack
	"X11",
	"xdg",
	NULL
};

#endif
