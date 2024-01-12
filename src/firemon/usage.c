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
#include "firemon.h"

static const char *const usage_str =
	"Usage: firemon [OPTIONS] [PID]\n\n"
	"Monitor processes started in a Firejail sandbox. Without any PID specified,\n"
	"all processes started by Firejail are monitored. Descendants of these processes\n"
	"are also being monitored. On Grsecurity systems only root user\n"
	"can run this program.\n\n"
	"Options:\n"
	"\t--apparmor - print AppArmor confinement status for each sandbox.\n\n"
	"\t--arp - print ARP table for each sandbox.\n\n"
	"\t--caps - print capabilities configuration for each sandbox.\n\n"
	"\t--cpu - print CPU affinity for each sandbox.\n\n"
	"\t--debug - print debug messages.\n\n"
	"\t--help, -? - this help screen.\n\n"
	"\t--interface - print network interface information for each sandbox.\n\n"
	"\t--list - list all sandboxes.\n\n"
	"\t--name=name - print information only about named sandbox.\n\n"
	"\t--netstats - monitor network statistics for sandboxes creating a new\n"
	"\t\tnetwork namespace.\n\n"
	"\t--route - print route table for each sandbox.\n\n"
	"\t--seccomp - print seccomp configuration for each sandbox.\n\n"
	"\t--tree - print a tree of all sandboxed processes.\n\n"
	"\t--top - monitor the most CPU-intensive sandboxes.\n\n"
	"\t--version - print program version and exit.\n\n"
	"\t--wrap - enable line wrapping in terminals.\n\n"
	"\t--x11 - print X11 display number.\n\n"

	"Without any options, firemon monitors all fork, exec, id change, and exit\n"
	"events in the sandbox. Monitoring a specific PID is also supported.\n\n"

	"Option --list prints a list of all sandboxes. The format for each entry is as\n"
	"follows:\n\n"
	"\tPID:USER:Command\n\n"

	"Option --tree prints the tree of processes running in the sandbox. The format\n"
	"for each process entry is as follows:\n\n"
	"\tPID:USER:Command\n\n"

	"Option --top is similar to the UNIX top command, however it applies only to\n"
	"sandboxes. Listed below are the available fields (columns) in alphabetical\n"
	"order:\n\n"
	"\tCommand - command used to start the sandbox.\n"
	"\tCPU%% - CPU usage, the sandbox share of the elapsed CPU time since the\n"
	"\t       last screen update\n"
	"\tPID - Unique process ID for the task controlling the sandbox.\n"
	"\tPrcs - number of processes running in sandbox, including the\n"
	"\t       controlling process.\n"
	"\tRES - Resident Memory Size (KiB), sandbox non-swapped physical memory.\n"
	"\t      It is a sum of the RES values for all processes running in the\n"
	"\t      sandbox.\n"
	"\tSHR - Shared Memory Size (KiB), it reflects memory shared with other\n"
	"\t      processes. It is a sum of the SHR values for all processes\n"
	"\t      running in the sandbox, including the controlling process.\n"
	"\tUptime - sandbox running time in hours:minutes:seconds format.\n"
	"\tUser - The owner of the sandbox.\n"
	"\n"
	"License GPL version 2 or later\n"
	"Homepage: https://firejail.wordpress.com\n";

void print_version(void) {
	printf("firemon version %s\n\n", VERSION);
}

void usage(void) {
	print_version();
	puts(usage_str);
}
