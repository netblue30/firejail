/*
 * Copyright (C) 2014-2016 Firejail Authors
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

#define MAX_READ 4096	// maximum line length
char *restricted_user = NULL;


int restricted_shell(const char *user) {
	EUID_ASSERT();
	assert(user);

	// open profile file:
	char *fname;
	if (asprintf(&fname, "%s/login.users", SYSCONFDIR) == -1)
		errExit("asprintf");
	FILE *fp = fopen(fname, "r");
	free(fname);
	if (fp == NULL)
		return 0;

	int lineno = 0;
	char buf[MAX_READ];
	while (fgets(buf, MAX_READ, fp)) {
		lineno++;
		
		// remove empty spaces at the beginning of the line
		char *ptr = buf;
		while (*ptr == ' ' || *ptr == '\t') { 
			ptr++;
		}
		if (*ptr == '\n' || *ptr == '#')
			continue;
		
		// parse line	
		char *usr = ptr;
		char *args = strchr(usr, ':');
		if (args == NULL) {
			fprintf(stderr, "Error: users.conf line %d\n", lineno);
			exit(1);
		}
		*args = '\0';
		args++;
		ptr = strchr(args, '\n');
		if (ptr)
			*ptr = '\0';
		
		// if nothing follows, continue
		char *ptr2 = args;
		int found = 0;
		while (*ptr2 != '\0') {
			if (*ptr2 != ' ' && *ptr2 != '\t') {
				found = 1;
				break;
			}
		}
		if (!found)
			continue;
		
		// process user
		if (strcmp(user, usr) == 0) {
		    	// extract program arguments

		    	fullargv[0] = "firejail";
		    	int i;
		    	ptr = args;
		    	for (i = 1; i < MAX_ARGS; i++) {
		    		fullargv[i] = ptr;
		    		while (*ptr != ' ' && *ptr != '\t' && *ptr != '\0')
		    			ptr++;
		    		if (*ptr != '\0') {
		    			*ptr ='\0';
		    			fullargv[i] = strdup(fullargv[i]);
		    			if (fullargv[i] == NULL) {
		    				fprintf(stderr, "Error: cannot allocate memory\n");
		    				exit(1);
		    			}
		    			ptr++;
		    			while (*ptr == ' ' || *ptr == '\t')
		    				ptr++;
		    			if (*ptr != '\0')
			    			continue;
		    		}
	    			fullargv[i] = strdup(fullargv[i]);
				fclose(fp);
		    		return i + 1;
			}
			fprintf(stderr, "Error: too many program arguments in users.conf line %d\n", lineno);
			exit(1);
		}
	}
	fclose(fp);
			 
	return 0;   
}

