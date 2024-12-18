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
#ifndef FIRECFG_H
#define FIRECFG_H
#define _GNU_SOURCE
#include <stdio.h>
#include <sys/types.h>
#include <dirent.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <grp.h>
#include <string.h>
#include <errno.h>
#include <sys/mman.h>
#include <pwd.h>
#include <dirent.h>

#include "../include/common.h"
#define MAX_BUF 4096

// config files
#define FIRECFG_CFGFILE SYSCONFDIR "/firecfg.config"
#define FIRECFG_CONF_GLOB SYSCONFDIR "/firecfg.d/*.conf"

// programs
#define FIREJAIL_EXEC PREFIX "/bin/firejail"
#define FIREJAIL_WELCOME_SH LIBDIR "/firejail/firejail-welcome.sh"
#define FZENITY_EXEC        LIBDIR "/firejail/fzenity"
#define ZENITY_EXEC "/usr/bin/zenity"
#define SUDO_EXEC "sudo"

// main.c
extern int arg_debug;
int in_ignorelist(const char *const str);
void parse_config_all(int do_symlink);

// util.c
int which(const char *program);
int is_link(const char *fname);

// sound.c
void sound(void);

// desktop_files.c
void fix_desktop_files(const char *homedir);

#endif
