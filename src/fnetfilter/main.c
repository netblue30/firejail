 /*
 * Copyright (C) 2014-2017 Firejail Authors
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
#include "../include/common.h"

#define MAXBUF 4098
int arg_quiet = 0;

static char *default_filter =
"*filter\n"
":INPUT DROP [0:0]\n"
":FORWARD DROP [0:0]\n"
":OUTPUT ACCEPT [0:0]\n"
"-A INPUT -i lo -j ACCEPT\n"
"-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT\n"
"# echo replay is handled by -m state RELATED/ESTABLISHED below\n"
"#-A INPUT -p icmp --icmp-type echo-reply -j ACCEPT\n"
"-A INPUT -p icmp --icmp-type destination-unreachable -j ACCEPT\n"
"-A INPUT -p icmp --icmp-type time-exceeded -j ACCEPT\n"
"-A INPUT -p icmp --icmp-type echo-request -j ACCEPT \n"
"# disable STUN\n"
"-A OUTPUT -p udp --dport 3478 -j DROP\n"
"-A OUTPUT -p udp --dport 3479 -j DROP\n"
"-A OUTPUT -p tcp --dport 3478 -j DROP\n"
"-A OUTPUT -p tcp --dport 3479 -j DROP\n"
"COMMIT\n";

static void usage(void) {
	printf("Usage:\n");
	printf("\tfnetfilter netfilter-command destination-file\n");
}

int main(int argc, char **argv) {
#if 0
{
system("cat /proc/self/status");
int i;
for (i = 0; i < argc; i++)
	printf("*%s* ", argv[i]);
printf("\n");
}
#endif

	char *quiet = getenv("FIREJAIL_QUIET");
	if (quiet && strcmp(quiet, "yes") == 0)
		arg_quiet = 1;

	if (strcmp(argv[1], "-h") == 0 || strcmp(argv[1], "--help") == 0 || strcmp(argv[1], "-?") ==0) {
		usage();
		return 0;
	}

	if (argc != 2 && argc != 3) {
		usage();
		return 1;
	}

	char *destfile = (argc == 3)? argv[2]: argv[1];
	char *command = (argc == 3)? argv[1]: NULL;	
//printf("command %s\n", command);
//printf("destfile %s\n", destfile);

	// handle default config (command = NULL, destfile)
	if (command == NULL) {
		// create a default filter file
		FILE *fp = fopen(destfile, "w");
		if (!fp) {
			fprintf(stderr, "Error fnetfilter: cannot open %s\n", destfile);
			exit(1);
		}
		fprintf(fp, "%s\n", default_filter);
		fclose(fp);
	}
	else {
		// copy the file
		FILE *fp1 = fopen(command, "r");
		if (!fp1) {
			fprintf(stderr, "Error fnetfilter: cannot open %s\n", command);
			exit(1);
		}

		FILE *fp2 = fopen(destfile, "w");
		if (!fp2) {
			fprintf(stderr, "Error fnetfilter: cannot open %s\n", destfile);
			exit(1);
		}
		
		char buf[MAXBUF];
		while (fgets(buf, MAXBUF, fp1))
			fprintf(fp2, "%s", buf);

		fclose(fp1);
		fclose(fp2);
	}
	

printf("fnetfilter running\n");
	return 0;
}
