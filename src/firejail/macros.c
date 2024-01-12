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
#include <sys/stat.h>
#define MAXBUF 4098

typedef struct macro_t {
	char *name;		// macro name
	char *xdg;		// xdg line in ~/.config/user-dirs.dirs
	// several translations in case ~/.config/user-dirs.dirs not found
	// covered currently: English, Russian, French, Italian, Spanish, Portuguese, German
#define MAX_TRANSLATIONS 7
	char *translation[MAX_TRANSLATIONS];
} Macro;

Macro macro[] = {
	{
		"${DOWNLOADS}",
		"XDG_DOWNLOAD_DIR=\"$HOME/",
		{"Downloads", "Загрузки", "Téléchargement", "Scaricati", "Descargas"}
	},

	{
		"${MUSIC}",
		"XDG_MUSIC_DIR=\"$HOME/",
		{"Music", "Музыка", "Musique", "Musica", "Música", "Musik"}
	},

	{
		"${VIDEOS}",
		"XDG_VIDEOS_DIR=\"$HOME/",
		{"Videos", "Видео", "Vidéos", "Video", "Vídeos"}
	},

	{
		"${PICTURES}",
		"XDG_PICTURES_DIR=\"$HOME/",
		{"Pictures", "Изображения", "Photos", "Immagini", "Imágenes", "Imagens", "Bilder"}
	},

	{
		"${DESKTOP}",
		"XDG_DESKTOP_DIR=\"$HOME/",
		{"Desktop", "Рабочий стол", "Bureau", "Scrivania", "Escritorio", "Área de trabalho", "Schreibtisch"}
	},

	{
		"${DOCUMENTS}",
		"XDG_DOCUMENTS_DIR=\"$HOME/",
		{"Documents", "Документы", "Documenti", "Documentos", "Dokumente"}
	},

	{ 0 }
};

// return -1 if not found
int macro_id(const char *name) {
	int i = 0;
	while (macro[i].name != NULL) {
		if (strcmp(name, macro[i].name) == 0)
			return i;
		i++;
	}

	return -1;
}

int is_macro(const char *name) {
	assert(name);
	int len = strlen(name);
	if (len <= 4)
		return 0;
	if (*name == '$' && name[1] == '{' && name[len - 1] == '}')
		return 1;
	return 0;
}

// returns mallocated memory
static char *resolve_xdg(const char *var) {
	EUID_ASSERT();
	char *fname;
	struct stat s;
	size_t length = strlen(var);

	if (asprintf(&fname, "%s/.config/user-dirs.dirs", cfg.homedir) == -1)
		errExit("asprintf");
	FILE *fp = fopen(fname, "re");
	if (!fp) {
		free(fname);
		return NULL;
	}
	free(fname);

	char buf[MAXBUF];
	while (fgets(buf, MAXBUF, fp)) {
		char *ptr = buf;

		// skip blanks
		while (*ptr == ' ' || *ptr == '\t')
			ptr++;
		if (*ptr == '\0' || *ptr == '\n' || *ptr == '#')
			continue;

		if (strncmp(ptr, var, length) == 0) {
			char *ptr1 = ptr + length;
			char *ptr2 = strchr(ptr1, '"');
			if (ptr2) {
				fclose(fp);
				*ptr2 = '\0';
				if (strlen(ptr1) != 0) {
					if (asprintf(&fname, "%s/%s", cfg.homedir, ptr1) == -1)
						errExit("asprintf");

					if (stat(fname, &s) == -1) {
						free(fname);
						return NULL;
					}
					free(fname);

					char *rv = strdup(ptr1);
					if (!rv)
						errExit(ptr1);
					return rv;
				}
				else
					return NULL;
			}
		}
	}

	fclose(fp);
	return NULL;
}

// returns mallocated memory
static char *resolve_hardcoded(char *entries[]) {
	EUID_ASSERT();
	char *fname;
	struct stat s;

	int i = 0;
	while (i < MAX_TRANSLATIONS && entries[i] != NULL) {
		if (asprintf(&fname, "%s/%s", cfg.homedir, entries[i]) == -1)
			errExit("asprintf");

		if (stat(fname, &s) == 0) {
			free(fname);
			char *rv = strdup(entries[i]);
			if (!rv)
				errExit("strdup");
			return rv;
		}
		free(fname);
		i++;
	}

	return NULL;
}

// returns mallocated memory
char *resolve_macro(const char *name) {
	char *rv = NULL;
	int id = macro_id(name);
	if (id == -1)
		return NULL;

	rv = resolve_xdg(macro[id].xdg);
	if (rv == NULL)
		rv = resolve_hardcoded(macro[id].translation);
	if (rv && arg_debug)
		printf("Directory %s resolved as %s\n", name, rv);

	return rv;
}

// This function takes a pathname supplied by the user and expands '~' and
// '${HOME}' at the start, to refer to a path relative to the user's home
// directory (supplied).
// The return value is allocated using malloc and must be freed by the caller.
// The function returns NULL if there are any errors.
char *expand_macros(const char *path) {
	assert(path);

	int called_as_root = 0;

	if(geteuid() == 0)
		called_as_root = 1;

	if(called_as_root) {
		EUID_USER();
	}

	EUID_ASSERT();

	// Replace home macro
	char *new_name = NULL;
	if (strncmp(path, "$HOME", 5) == 0) {
		fprintf(stderr, "Error: $HOME is not allowed in profile files, please replace it with ${HOME}\n");
		exit(1);
	}
	else if (strncmp(path, "${HOME}", 7) == 0) {
		if (asprintf(&new_name, "%s%s", cfg.homedir, path + 7) == -1)
			errExit("asprintf");
		if(called_as_root)
			EUID_ROOT();
		return new_name;
	}
	else if (*path == '~') {
		if (asprintf(&new_name, "%s%s", cfg.homedir, path + 1) == -1)
			errExit("asprintf");
		if(called_as_root)
			EUID_ROOT();
		return new_name;
	}
	else if (strncmp(path, "${CFG}", 6) == 0) {
		if (asprintf(&new_name, "%s%s", SYSCONFDIR, path + 6) == -1)
			errExit("asprintf");
		if(called_as_root)
			EUID_ROOT();
		return new_name;
	}
	else if (strncmp(path, "${RUNUSER}", 10) == 0) {
		if (asprintf(&new_name, "/run/user/%u%s", getuid(), path + 10) == -1)
			errExit("asprintf");
		if(called_as_root)
			EUID_ROOT();
		return new_name;
	}
	else {
		char *directory = resolve_macro(path);
		if (directory) {
			if (asprintf(&new_name, "%s/%s", cfg.homedir, directory) == -1)
				errExit("asprintf");
			if(called_as_root)
				EUID_ROOT();
			free(directory);
			return new_name;
		}
	}

	char *rv = strdup(path);
	if (!rv)
		errExit("strdup");

	if(called_as_root)
		EUID_ROOT();

	return rv;
}

void invalid_filename(const char *fname, int globbing) {
//	EUID_ASSERT();
	assert(fname);
	const char *ptr = fname;

	if (strncmp(ptr, "${HOME}", 7) == 0)
		ptr = fname + 7;
	else if (strncmp(ptr, "${PATH}", 7) == 0)
		ptr = fname + 7;
	else if (strncmp(ptr, "${RUNUSER}", 10) == 0)
		ptr = fname + 10;
	else {
		int id = macro_id(fname);
		if (id != -1)
			return;
	}

	reject_meta_chars(ptr, globbing);
}
