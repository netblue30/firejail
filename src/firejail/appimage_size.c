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

/*
 * This code borrows heavily from src/libappimage_shared/elf.c in libappimage
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
	Elf32_Shdr shdr32;
	off_t last_shdr_offset;
	ssize_t ret;
	unsigned long sht_end, last_section_end;

	ret = pread(fd, &ehdr32, sizeof(ehdr32), 0);
	if (ret < 0 || (size_t)ret != sizeof(ehdr))
		return 0;

	ehdr.e_shoff            = file32_to_cpu(ehdr32.e_shoff);
	ehdr.e_shentsize        = file16_to_cpu(ehdr32.e_shentsize);
	ehdr.e_shnum            = file16_to_cpu(ehdr32.e_shnum);

	last_shdr_offset = ehdr.e_shoff + (ehdr.e_shentsize * (ehdr.e_shnum - 1));
	ret = pread(fd, &shdr32, sizeof(shdr32), last_shdr_offset);
	if (ret < 0 || (size_t)ret != sizeof(shdr32))
		return 0;

	/* ELF ends either with the table of section headers (SHT) or with a section. */
	sht_end = ehdr.e_shoff + (ehdr.e_shentsize * ehdr.e_shnum);
	last_section_end = file64_to_cpu(shdr32.sh_offset) + file64_to_cpu(shdr32.sh_size);
	return sht_end > last_section_end ? sht_end : last_section_end;
}


// return 0 if error
static long unsigned int read_elf64(int fd) {
	Elf64_Ehdr ehdr64;
	Elf64_Shdr shdr64;
	off_t last_shdr_offset;
	ssize_t ret;
	unsigned long sht_end, last_section_end;

	ret = pread(fd, &ehdr64, sizeof(ehdr64), 0);
	if (ret < 0 || (size_t)ret != sizeof(ehdr))
		return 0;

	ehdr.e_shoff            = file64_to_cpu(ehdr64.e_shoff);
	ehdr.e_shentsize        = file16_to_cpu(ehdr64.e_shentsize);
	ehdr.e_shnum            = file16_to_cpu(ehdr64.e_shnum);

	last_shdr_offset = ehdr.e_shoff + (ehdr.e_shentsize * (ehdr.e_shnum - 1));
	ret = pread(fd, &shdr64, sizeof(shdr64), last_shdr_offset);
	if (ret < 0 || (size_t)ret != sizeof(shdr64))
		return 0;

	/* ELF ends either with the table of section headers (SHT) or with a section. */
	sht_end = ehdr.e_shoff + (ehdr.e_shentsize * ehdr.e_shnum);
	last_section_end = file64_to_cpu(shdr64.sh_offset) + file64_to_cpu(shdr64.sh_size);
	return sht_end > last_section_end ? sht_end : last_section_end;
}


// return 0 if error
// return 0 if this is not an appimgage2 file
long unsigned int appimage2_size(int fd) {
	ssize_t ret;
	long unsigned int size = 0;

	if (fd < 0)
		return 0;

	ret = pread(fd, ehdr.e_ident, EI_NIDENT, 0);
	if (ret != EI_NIDENT)
		return 0;

	if ((ehdr.e_ident[EI_DATA] != ELFDATA2LSB) &&
	    (ehdr.e_ident[EI_DATA] != ELFDATA2MSB))
		return 0;

	if(ehdr.e_ident[EI_CLASS] == ELFCLASS32) {
		size = read_elf32(fd);
	}
	else if(ehdr.e_ident[EI_CLASS] == ELFCLASS64) {
		size = read_elf64(fd);
	}
	else {
		return 0;
	}
	if (size == 0)
		return 0;


	// look for a LZMA header at this location
	unsigned char buf[4];
	ret = pread(fd, buf, 4, size);
	if (ret != 4)
		return 0;
	if (memcmp(buf, "hsqs", 4) != 0)
		return 0;

	return size;
}
