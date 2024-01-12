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
#ifndef JAILCHECK_H
#define JAILCHECK_H

#include "../include/common.h"

// main.c
extern uid_t user_uid;
extern gid_t user_gid;
extern char *user_name;
extern char *user_home_dir;
extern char *user_run_dir;

// access.c
void access_setup(const char *directory);
void access_test(void);
void access_destroy(void);

// noexec.c
void noexec_setup(void);
void noexec_test(const char *msg);

// sysfiles.c
void sysfiles_setup(const char *file);
void sysfiles_test(void);

// virtual.c
void virtual_setup(const char *directory);
void virtual_destroy(void);
void virtual_test(void);

// apparmor.c
void apparmor_test(pid_t pid);

// seccomp.c
void seccomp_test(pid_t pid);

// network.c
void network_test(void);
// utils.c
char *get_sudo_user(void);
char *get_homedir(const char *user, uid_t *uid, gid_t *gid);
int find_child(pid_t pid);
pid_t switch_to_child(pid_t pid);

#endif
