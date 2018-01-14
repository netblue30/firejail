/*
 * Copyright (C) 2014-2018 Firejail Authors
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
/*
Compile with:
gcc elfsize.c -o elfsize
Example:
ls -l						126584
Calculation using the values also reported by readelf -h:
Start of section headers	e_shoff		124728
Size of section headers		e_shentsize	64
Number of section headers	e_shnum		29
e_shoff + ( e_shentsize * e_shnum ) =		126584
*/
#include <elf.h>
#include <byteswap.h>
#include <stdio.h>
#include <stdint.h>
#include <errno.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>

typedef Elf32_Nhdr Elf_Nhdr;

static Elf64_Ehdr ehdr;

#if __BYTE_ORDER == __LITTLE_ENDIAN
#define ELFDATANATIVE ELFDATA2LSB
#elif __BYTE_ORDER == __BIG_ENDIAN
#define ELFDATANATIVE ELFDATA2MSB
#else
#error "Unknown machine endian"
#endif

static uint16_t file16_to_cpu(uint16_t val) {
	if (ehdr.e_ident[EI_DATA] != ELFDATANATIVE)
		val = bswap_16(val);
	return val;
}


static uint32_t file32_to_cpu(uint32_t val) {
	if (ehdr.e_ident[EI_DATA] != ELFDATANATIVE)
		val = bswap_32(val);
	return val;
}


static uint64_t file64_to_cpu(uint64_t val) {
	if (ehdr.e_ident[EI_DATA] != ELFDATANATIVE)
		val = bswap_64(val);
	return val;
}


// return 0 if error
static long unsigned int read_elf32(int fd) {
	Elf32_Ehdr ehdr32;
	ssize_t ret;

	ret = pread(fd, &ehdr32, sizeof(ehdr32), 0);
	if (ret < 0 || (size_t)ret != sizeof(ehdr))
		return 0;

	ehdr.e_shoff            = file32_to_cpu(ehdr32.e_shoff);
	ehdr.e_shentsize        = file16_to_cpu(ehdr32.e_shentsize);
	ehdr.e_shnum            = file16_to_cpu(ehdr32.e_shnum);

	return(ehdr.e_shoff + (ehdr.e_shentsize * ehdr.e_shnum));
}


// return 0 if error
static long unsigned int read_elf64(int fd) {
	Elf64_Ehdr ehdr64;
	ssize_t ret;

	ret = pread(fd, &ehdr64, sizeof(ehdr64), 0);
	if (ret < 0 || (size_t)ret != sizeof(ehdr))
		return 0;

	ehdr.e_shoff            = file64_to_cpu(ehdr64.e_shoff);
	ehdr.e_shentsize        = file16_to_cpu(ehdr64.e_shentsize);
	ehdr.e_shnum            = file16_to_cpu(ehdr64.e_shnum);

	return(ehdr.e_shoff + (ehdr.e_shentsize * ehdr.e_shnum));
}


// return 0 if error
// return 0 if this is not an appimgage2 file
long unsigned int appimage2_size(const char *fname) {
/* TODO, FIXME: This assumes that the section header table (SHT) is
the last part of the ELF. This is usually the case but
it could also be that the last section is the last part
of the ELF. This should be checked for.
*/
	ssize_t ret;
	int fd;
	long unsigned int size = 0;

	fd = open(fname, O_RDONLY);
	if (fd < 0)
		return 0;

	ret = pread(fd, ehdr.e_ident, EI_NIDENT, 0);
	if (ret != EI_NIDENT)
		goto getout;

	if ((ehdr.e_ident[EI_DATA] != ELFDATA2LSB) &&
	     (ehdr.e_ident[EI_DATA] != ELFDATA2MSB))
		goto getout;

	if(ehdr.e_ident[EI_CLASS] == ELFCLASS32) {
		size = read_elf32(fd);
	}
	else if(ehdr.e_ident[EI_CLASS] == ELFCLASS64) {
		size = read_elf64(fd);
	}
	else {
		goto getout;
	}
	if (size == 0)
		goto getout;


	// look for a LZMA header at this location
	unsigned char buf[4];
	ret = pread(fd, buf, 4, size);
	if (ret != 4) {
		size = 0;
		goto getout;
	}
	if (memcmp(buf, "hsqs", 4) != 0)
		size = 0;

getout:
	close(fd);
	return size;
}
