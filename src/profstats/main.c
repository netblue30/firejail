 /*
 * Copyright (C) 2014-2020 Firejail Authors
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
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#define MAXBUF 2048
// stats
static int cnt_profiles = 0;
static int cnt_apparmor = 0;
static int cnt_seccomp = 0;
static int cnt_caps = 0;
static int cnt_dbus_system_none = 0;
static int cnt_dbus_user_none = 0;
static int cnt_dotlocal = 0;
static int cnt_globalsdotlocal = 0;
static int cnt_netnone = 0;
static int cnt_noexec = 0;	// include disable-exec.inc
static int cnt_privatebin = 0;
static int cnt_privatedev = 0;
static int cnt_privatetmp = 0;
static int cnt_privateetc = 0;
static int cnt_whitelistvar = 0;	// include whitelist-var-common.inc
static int cnt_whitelistrunuser = 0;	// include whitelist-runuser-common.inc
static int cnt_whitelistusrshare = 0;	// include whitelist-usr-share-common.inc
static int cnt_ssh = 0;
static int cnt_mdwx = 0;
static int cnt_whitelisthome = 0;

static int level = 0;
static int arg_debug = 0;
static int arg_apparmor = 0;
static int arg_caps = 0;
static int arg_seccomp = 0;
static int arg_noexec = 0;
static int arg_privatebin = 0;
static int arg_privatedev = 0;
static int arg_privatetmp = 0;
static int arg_privateetc = 0;
static int arg_whitelistvar = 0;
static int arg_whitelistrunuser = 0;
static int arg_whitelistusrshare = 0;
static int arg_ssh = 0;
static int arg_mdwx = 0;
static int arg_dbus_system_none = 0;
static int arg_dbus_user_none = 0;
static int arg_whitelisthome = 0;


static char *profile = NULL;


static void usage(void) {
	printf("proftool - print profile statistics\n");
	printf("Usage: proftool [options] file[s]\n");
	printf("Options:\n");
	printf("   --apparmor - print profiles without apparmor\n");
	printf("   --caps - print profiles without caps\n");
	printf("   --dbus-system-none - profiles without  \"dbus-system none\"\n");
	printf("   --dbus-user-none - profiles without  \"dbus-user none\"\n");
	printf("   --ssh - print profiles without \"include disable-common.inc\"\n");
	printf("   --noexec - print profiles without \"include disable-exec.inc\"\n");
	printf("   --private-bin - print profiles without private-bin\n");
	printf("   --private-dev - print profiles without private-dev\n");
	printf("   --private-etc - print profiles without private-etc\n");
	printf("   --private-tmp - print profiles without private-tmp\n");
	printf("   --seccomp - print profiles without seccomp\n");
	printf("   --memory-deny-write-execute - profile without \"memory-deny-write-execute\"\n");
	printf("   --whitelist-home - print profiles whitelisting home directory\n");
	printf("   --whitelist-var - print profiles without \"include whitelist-var-common.inc\"\n");
	printf("   --whitelist-runuser - print profiles without \"include whitelist-runuser-common.inc\" or \"blacklist ${RUNUSER}\"\n");
	printf("   --whitelist-usrshare - print profiles without \"include whitelist-usr-share-common.inc\"\n");
	printf("   --debug\n");
	printf("\n");
}

void process_file(const char *fname) {
	assert(fname);

	if (arg_debug)
		printf("processing #%s#\n", fname);
	level++;
	assert(level < 32); // to do - check in firejail code

	FILE *fp = fopen(fname, "r");
	if (!fp) {
		fprintf(stderr, "Warning: cannot open %s, while processing %s\n", fname, profile);
		level--;
		return;
	}

	char buf[MAXBUF];
	while (fgets(buf, MAXBUF, fp)) {
		char *ptr = strchr(buf, '\n');
		if (ptr)
			*ptr = '\0';
		ptr = buf;

		while (*ptr == ' ' || *ptr == '\t')
			ptr++;
		if (*ptr == '\n' || *ptr == '#')
			continue;

		if (strncmp(ptr, "seccomp", 7) == 0)
			cnt_seccomp++;
		else if (strncmp(ptr, "caps", 4) == 0)
			cnt_caps++;
		else if (strncmp(ptr, "include disable-exec.inc", 24) == 0)
			cnt_noexec++;
		else if (strncmp(ptr, "include whitelist-var-common.inc", 32) == 0)
			cnt_whitelistvar++;
		else if (strncmp(ptr, "include whitelist-runuser-common.inc", 36) == 0 ||
		        strncmp(ptr, "blacklist ${RUNUSER}", 20) == 0)
			cnt_whitelistrunuser++;
		else if (strncmp(ptr, "include whitelist-common.inc", 28) == 0)
			cnt_whitelisthome++;
		else if (strncmp(ptr, "include whitelist-usr-share-common.inc", 38) == 0)
			cnt_whitelistusrshare++;
		else if (strncmp(ptr, "include disable-common.inc", 26) == 0)
			cnt_ssh++;
		else if (strncmp(ptr, "memory-deny-write-execute", 25) == 0)
			cnt_mdwx++;
		else if (strncmp(ptr, "net none", 8) == 0)
			cnt_netnone++;
		else if (strncmp(ptr, "apparmor", 8) == 0)
			cnt_apparmor++;
		else if (strncmp(ptr, "private-bin", 11) == 0)
			cnt_privatebin++;
		else if (strncmp(ptr, "private-dev", 11) == 0)
			cnt_privatedev++;
		else if (strncmp(ptr, "private-tmp", 11) == 0)
			cnt_privatetmp++;
		else if (strncmp(ptr, "private-etc", 11) == 0)
			cnt_privateetc++;
		else if (strncmp(ptr, "dbus-system none", 16) == 0)
			cnt_dbus_system_none++;
		else if (strncmp(ptr, "dbus-user none", 14) == 0)
			cnt_dbus_user_none++;
		else if (strncmp(ptr, "include ", 8) == 0) {
			// not processing .local files
			if (strstr(ptr, ".local")) {
//printf("dotlocal %d, level %d - #%s#, redirect #%s#\n", cnt_dotlocal, level, fname, buf + 8);
				if (strstr(ptr, "globals.local"))
					cnt_globalsdotlocal++;
				else
					cnt_dotlocal++;
				continue;
			}
			// clean blanks
			char *ptr = buf + 8;
			while (*ptr != '\0' && *ptr != ' ' && *ptr != '\t')
				ptr++;
			*ptr = '\0';
			process_file(buf + 8);
		}
	}

	fclose(fp);
	level--;
}

int main(int argc, char **argv) {
	if (argc <= 1) {
		usage();
		return 1;
	}

	int start = 1;
	int i;
	for (i = 1; i < argc; i++) {
		if (strcmp(argv[i], "--help") == 0) {
			usage();
			return 0;
		}
		else if (strcmp(argv[i], "--debug") == 0)
			arg_debug = 1;
		else if (strcmp(argv[i], "--apparmor") == 0)
			arg_apparmor = 1;
		else if (strcmp(argv[i], "--caps") == 0)
			arg_caps = 1;
		else if (strcmp(argv[i], "--seccomp") == 0)
			arg_seccomp = 1;
		else if (strcmp(argv[i], "--memory-deny-write-execute") == 0)
			arg_mdwx = 1;
		else if (strcmp(argv[i], "--noexec") == 0)
			arg_noexec = 1;
		else if (strcmp(argv[i], "--private-bin") == 0)
			arg_privatebin = 1;
		else if (strcmp(argv[i], "--private-dev") == 0)
			arg_privatedev = 1;
		else if (strcmp(argv[i], "--private-tmp") == 0)
			arg_privatetmp = 1;
		else if (strcmp(argv[i], "--private-etc") == 0)
			arg_privateetc = 1;
		else if (strcmp(argv[i], "--whitelist-home") == 0)
			arg_whitelisthome = 1;
		else if (strcmp(argv[i], "--whitelist-var") == 0)
			arg_whitelistvar = 1;
		else if (strcmp(argv[i], "--whitelist-runuser") == 0)
			arg_whitelistrunuser = 1;
		else if (strcmp(argv[i], "--whitelist-usrshare") == 0)
			arg_whitelistusrshare = 1;
		else if (strcmp(argv[i], "--ssh") == 0)
			arg_ssh = 1;
		else if (strcmp(argv[i], "--dbus-system-none") == 0)
			arg_dbus_system_none = 1;
		else if (strcmp(argv[i], "--dbus-user-none") == 0)
			arg_dbus_user_none = 1;
		else if (*argv[i] == '-') {
			fprintf(stderr, "Error: invalid option %s\n", argv[i]);
		 	return 1;
		 }
		 else
		 	break;
	}

	start = i;
	if (i == argc) {
		fprintf(stderr, "Error: no profile file specified\n");
		return 1;
	}

	for (i = start; i < argc; i++) {
		cnt_profiles++;

		// watch seccomp
		int seccomp = cnt_seccomp;
		int caps = cnt_caps;
		int apparmor = cnt_apparmor;
		int noexec = cnt_noexec;
		int privatebin = cnt_privatebin;
		int privatetmp = cnt_privatetmp;
		int privatedev = cnt_privatedev;
		int privateetc = cnt_privateetc;
		int dotlocal = cnt_dotlocal;
		int globalsdotlocal = cnt_globalsdotlocal;
		int whitelisthome = cnt_whitelisthome;
		int whitelistvar = cnt_whitelistvar;
		int whitelistrunuser = cnt_whitelistrunuser;
		int whitelistusrshare = cnt_whitelistusrshare;
		int dbussystemnone = cnt_dbus_system_none;
		int dbususernone = cnt_dbus_user_none;
		int ssh = cnt_ssh;
		int mdwx = cnt_mdwx;

		// process file
		profile = argv[i];
		process_file(argv[i]);

		// warnings
		if ((caps + 2) <= cnt_caps) {
			printf("Warning: multiple caps in %s\n", argv[i]);
			cnt_caps = caps + 1;
		}

		// fix redirections
		if (cnt_dotlocal > (dotlocal + 1))
			cnt_dotlocal = dotlocal + 1;
		if (cnt_globalsdotlocal > (globalsdotlocal + 1))
			cnt_globalsdotlocal = globalsdotlocal + 1;
		if (cnt_whitelistrunuser > (whitelistrunuser + 1))
			cnt_whitelistrunuser = whitelistrunuser + 1;

		if (arg_dbus_system_none && dbussystemnone == cnt_dbus_system_none)
			printf("No dbus-system none found in %s\n", argv[i]);
		if (arg_dbus_user_none && dbususernone == cnt_dbus_user_none)
			printf("No dbus-user none found in %s\n", argv[i]);
		if (arg_apparmor && apparmor == cnt_apparmor)
			printf("No apparmor found in %s\n", argv[i]);
		if (arg_caps && caps == cnt_caps)
			printf("No caps found in %s\n", argv[i]);
		if (arg_seccomp && seccomp == cnt_seccomp)
			printf("No seccomp found in %s\n", argv[i]);
		if (arg_noexec && noexec == cnt_noexec)
			printf("No include disable-exec.inc found in %s\n", argv[i]);
		if (arg_privatedev && privatedev == cnt_privatedev)
			printf("No private-dev found in %s\n", argv[i]);
		if (arg_privatebin && privatebin == cnt_privatebin)
			printf("No private-bin found in %s\n", argv[i]);
		if (arg_privatetmp && privatetmp == cnt_privatetmp)
			printf("No private-tmp found in %s\n", argv[i]);
		if (arg_privateetc && privateetc == cnt_privateetc)
			printf("No private-etc found in %s\n", argv[i]);
		if (arg_whitelisthome && whitelisthome == cnt_whitelisthome)
			printf("Home directory not whitelisted in %s\n", argv[i]);
		if (arg_whitelistvar && whitelistvar == cnt_whitelistvar)
			printf("No include whitelist-var-common.inc found in %s\n", argv[i]);
		if (arg_whitelistrunuser && whitelistrunuser == cnt_whitelistrunuser)
			printf("No include whitelist-runuser-common.inc found in %s\n", argv[i]);
		if (arg_whitelistusrshare && whitelistusrshare == cnt_whitelistusrshare)
			printf("No include whitelist-usr-share-common.inc found in %s\n", argv[i]);
		if (arg_ssh && ssh == cnt_ssh)
			printf("No include disable-common.inc found in %s\n", argv[i]);
		if (arg_mdwx && mdwx == cnt_mdwx)
			printf("No memory-deny-write-execute found in %s\n", argv[i]);

		assert(level == 0);
	}

	printf("\n");
	printf("Stats:\n");
	printf("    profiles\t\t\t%d\n", cnt_profiles);
	printf("    include local profile\t%d   (include profile-name.local)\n", cnt_dotlocal);
	printf("    include globals\t\t%d   (include globals.local)\n", cnt_dotlocal);
	printf("    blacklist ~/.ssh\t\t%d   (include disable-common.inc)\n", cnt_ssh);
	printf("    seccomp\t\t\t%d\n", cnt_seccomp);
	printf("    capabilities\t\t%d\n", cnt_caps);
	printf("    noexec\t\t\t%d   (include disable-exec.inc)\n", cnt_noexec);
	printf("    memory-deny-write-execute\t%d\n", cnt_mdwx);
	printf("    apparmor\t\t\t%d\n", cnt_apparmor);
	printf("    private-bin\t\t\t%d\n", cnt_privatebin);
	printf("    private-dev\t\t\t%d\n", cnt_privatedev);
	printf("    private-etc\t\t\t%d\n", cnt_privateetc);
	printf("    private-tmp\t\t\t%d\n", cnt_privatetmp);
	printf("    whitelist home directory\t%d\n", cnt_whitelisthome);
	printf("    whitelist var\t\t%d   (include whitelist-var-common.inc)\n", cnt_whitelistvar);
	printf("    whitelist run/user\t\t%d   (include whitelist-runuser-common.inc\n", cnt_whitelistrunuser);
	printf("\t\t\t\t\tor blacklist ${RUNUSER})\n");
	printf("    whitelist usr/share\t\t%d   (include whitelist-usr-share-common.inc\n", cnt_whitelistusrshare);
	printf("    net none\t\t\t%d\n", cnt_netnone);
	printf("    dbus-user none \t\t%d\n", cnt_dbus_user_none);
	printf("    dbus-system none \t\t%d\n", cnt_dbus_system_none);
	printf("\n");
	return 0;
}
