/*
 * Copyright (C) 2014-2023 Firejail Authors
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

#ifdef HAVE_LANDLOCK
#define _GNU_SOURCE
#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/prctl.h>
#include <linux/prctl.h>
#include <linux/landlock.h>

int landlock_create_ruleset(struct landlock_ruleset_attr *rsattr,size_t size,__u32 flags) {
	return syscall(__NR_landlock_create_ruleset,rsattr,size,flags);
}

int landlock_add_rule(int fd,enum landlock_rule_type t,void *attr,__u32 flags) {
	return syscall(__NR_landlock_add_rule,fd,t,attr,flags);
}

int landlock_restrict_self(int fd,__u32 flags) {
	prctl(PR_SET_NO_NEW_PRIVS,1,0,0,0);
	int result = syscall(__NR_landlock_restrict_self,fd,flags);
	if (result!=0) return result;
	else {
		close(fd);
		return 0;
	}
}

int create_full_ruleset() {
	struct landlock_ruleset_attr attr;
	attr.handled_access_fs = LANDLOCK_ACCESS_FS_READ_FILE | LANDLOCK_ACCESS_FS_READ_DIR | LANDLOCK_ACCESS_FS_WRITE_FILE |
		LANDLOCK_ACCESS_FS_REMOVE_FILE | LANDLOCK_ACCESS_FS_REMOVE_DIR | LANDLOCK_ACCESS_FS_MAKE_CHAR | LANDLOCK_ACCESS_FS_MAKE_DIR |
		LANDLOCK_ACCESS_FS_MAKE_REG | LANDLOCK_ACCESS_FS_MAKE_SOCK | LANDLOCK_ACCESS_FS_MAKE_FIFO | LANDLOCK_ACCESS_FS_MAKE_BLOCK |
		LANDLOCK_ACCESS_FS_MAKE_SYM | LANDLOCK_ACCESS_FS_EXECUTE;
	return landlock_create_ruleset(&attr,sizeof(attr),0);
}

int add_read_access_rule_by_path(int rset_fd,char *allowed_path) {
	int result;
	int allowed_fd = open(allowed_path,O_PATH | O_CLOEXEC);
	struct landlock_path_beneath_attr target;
	target.parent_fd = allowed_fd;
	target.allowed_access = LANDLOCK_ACCESS_FS_READ_FILE | LANDLOCK_ACCESS_FS_READ_DIR;
	result = landlock_add_rule(rset_fd,LANDLOCK_RULE_PATH_BENEATH,&target,0);
	close(allowed_fd);
	return result;
}

int add_write_access_rule_by_path(int rset_fd,char *allowed_path) {
	int result;
	int allowed_fd = open(allowed_path,O_PATH | O_CLOEXEC);
	struct landlock_path_beneath_attr target;
	target.parent_fd = allowed_fd;
	target.allowed_access = LANDLOCK_ACCESS_FS_WRITE_FILE | LANDLOCK_ACCESS_FS_REMOVE_FILE | LANDLOCK_ACCESS_FS_REMOVE_DIR |
	                        LANDLOCK_ACCESS_FS_MAKE_CHAR | LANDLOCK_ACCESS_FS_MAKE_DIR | LANDLOCK_ACCESS_FS_MAKE_REG |
	                        LANDLOCK_ACCESS_FS_MAKE_SYM;
	result = landlock_add_rule(rset_fd,LANDLOCK_RULE_PATH_BENEATH,&target,0);
	close(allowed_fd);
	return result;
}

int add_create_special_rule_by_path(int rset_fd,char *allowed_path) {
	int result;
	int allowed_fd = open(allowed_path,O_PATH | O_CLOEXEC);
	struct landlock_path_beneath_attr target;
	target.parent_fd = allowed_fd;
	target.allowed_access = LANDLOCK_ACCESS_FS_MAKE_SOCK | LANDLOCK_ACCESS_FS_MAKE_FIFO | LANDLOCK_ACCESS_FS_MAKE_BLOCK;
	result = landlock_add_rule(rset_fd,LANDLOCK_RULE_PATH_BENEATH,&target,0);
	close(allowed_fd);
	return result;
}

int add_execute_rule_by_path(int rset_fd,char *allowed_path) {
	int result;
	int allowed_fd = open(allowed_path,O_PATH | O_CLOEXEC);
	struct landlock_path_beneath_attr target;
	target.parent_fd = allowed_fd;
	target.allowed_access = LANDLOCK_ACCESS_FS_EXECUTE;
	result = landlock_add_rule(rset_fd,LANDLOCK_RULE_PATH_BENEATH,&target,0);
	close(allowed_fd);
	return result;
}
#endif
