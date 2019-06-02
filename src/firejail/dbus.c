/*
 * Copyright (C) 2014-2018 Firejail Authors
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
#include "firejail.h"

void dbus_session_disable(void) {
	if (!checkcfg(CFG_DBUS)) {
		fwarning("D-Bus handling is disabled in Firejail configuration file\n");
		return;
	}

	char *path;
	if (asprintf(&path, "/run/user/%d/bus", getuid()) == -1)
		errExit("asprintf");
	char *env_var;
	if (asprintf(&env_var, "unix:path=%s", path) == -1)
		errExit("asprintf");

	// set a new environment variable: DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/<UID>/bus
	if (setenv("DBUS_SESSION_BUS_ADDRESS", env_var, 1) == -1) {
		fprintf(stderr, "Error: cannot modify DBUS_SESSION_BUS_ADDRESS required by --nodbus\n");
		exit(1);
	}

	// blacklist the path
	disable_file_or_dir(path);
	free(path);
	free(env_var);

	// blacklist the dbus-launch user directory
	if (asprintf(&path, "%s/.dbus", cfg.homedir) == -1)
		errExit("asprintf");
	disable_file_or_dir(path);
	free(path);

	// look for a possible abstract unix socket

	// --net=none
	if (arg_nonetwork)
		return;

	// --net=eth0
	if (any_bridge_configured())
		return;

	// --protocol=unix
#ifdef HAVE_SECCOMP
	if (cfg.protocol && !strstr(cfg.protocol, "unix"))
		return;
#endif

	fwarning("An abstract unix socket for session D-BUS might still be available. Use --net or remove unix from --protocol set.\n");
}
