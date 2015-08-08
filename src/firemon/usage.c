/*
 * Copyright (C) 2014, 2015 netblue30 (netblue30@yahoo.com)
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

void usage(void) {
	printf("firemon - version %s\n", VERSION);
	printf("Usage: firemon [OPTIONS] [PID]\n\n");
	printf("Monitor processes started in a Firejail sandbox. Without any PID specified,\n");
	printf("all processes started by Firejail are monitored. Descendants of these processes\n");
	printf("are also being monitored.\n\n");
	printf("Options:\n");
	printf("\t--arp - print ARP table for each sandbox.\n\n");
	printf("\t--caps - print capabilities configuration for each sandbox.\n\n");
	printf("\t--cgroup - print control group information for each sandbox.\n\n");
	printf("\t--cpu - print CPU affinity for each sandbox.\n\n");
	printf("\t--help, -? - this help screen.\n\n");
	printf("\t--interface - print network interface information for each sandbox.\n\n");
	printf("\t--list - list all sandboxes.\n\n");
	printf("\t--name=name - print information only about named sandbox.\n\n");
	printf("\t--netstats - monitor network statistics for sandboxes creating a new\n");
	printf("\t\tnetwork namespace.\n\n");
	printf("\t--route - print route table for each sandbox.\n\n");
	printf("\t--seccomp - print seccomp configuration for each sandbox.\n\n");
	printf("\t--tree - print a tree of all sandboxed processes.\n\n");
	printf("\t--top - monitor the most CPU-intensive sandboxes.\n\n");
	printf("\t--version - print program version and exit.\n\n");

	printf("Without any options, firemon monitors all fork, exec, id change, and exit events\n");
	printf("in the sandbox. Monitoring a specific PID is also supported.\n\n");

	printf("Option --list prints a list of all sandboxes. The format for each entry is as\n");
	printf("follows:\n\n");
	printf("\tPID:USER:Command\n\n");

	printf("Option --tree prints the tree of processes running in the sandbox. The format\n");
	printf("for each process entry is as follows:\n\n");
	printf("\tPID:USER:Command\n\n");

	printf("Option --top is similar to the UNIX top command, however it applies only to\n");
	printf("sandboxes. Listed below are the available fields (columns) in alphabetical\n");
	printf("order:\n\n");
	printf("\tCommand - command used to start the sandbox.\n");
	printf("\tCPU%% - CPU usage, the sandbox share of the elapsed CPU time since the\n");
	printf("\t       last screen update\n");
	printf("\tPID - Unique process ID for the task controlling the sandbox.\n");
	printf("\tPrcs - number of processes running in sandbox, including the controlling\n");
	printf("\t       process.\n");
	printf("\tRES - Resident Memory Size (KiB), sandbox non-swapped physical memory.\n");
	printf("\t      It is a sum of the RES values for all processes running in the\n");
	printf("\t      sandbox.\n");
	printf("\tSHR - Shared Memory Size (KiB), it reflects memory shared with other\n");
	printf("\t      processes. It is a sum of the SHR values for all processes running\n");
	printf("\t      in the sandbox, including the controlling process.\n");
	printf("\tUptime - sandbox running time in hours:minutes:seconds format.\n");
	printf("\tUser - The owner of the sandbox.\n");
	printf("\n");
	printf("License GPL version 2 or later\n");
	printf("Homepage: http://firejail.sourceforge.net\n");
	printf("\n");
}
