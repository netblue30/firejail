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
#include "firejail.h"
#include <fcntl.h>
#include <signal.h>

void shut(pid_t pid) {
	EUID_ASSERT();

	ProcessHandle sandbox = pin_sandbox_process(pid);

	process_send_signal(sandbox, SIGTERM);

	// wait for not more than 11 seconds
	int monsec = 11;
	int killdone = 0;

	while (monsec) {
		sleep(1);
		monsec--;

		int monfd = process_open_nofail(sandbox, "cmdline");
		if (monfd < 0) {
			killdone = 1;
			break;
		}

		char c;
		ssize_t count = read(monfd, &c, 1);
		close(monfd);
		if (count == 0) {
			// all done
			killdone = 1;
			break;
		}
	}

	// force SIGKILL
	if (!killdone)
		process_send_signal(sandbox, SIGKILL);

	unpin_process(sandbox);
}
