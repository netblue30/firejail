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
#include "fseccomp.h"
#include "../include/seccomp.h"
#include <sys/personality.h>
#include <sys/syscall.h>

static void write_filter(const char *fname, size_t size, const void *filter) {
	// save filter to file
	int dst = open(fname, O_CREAT|O_WRONLY|O_TRUNC, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
	if (dst < 0) {
		fprintf(stderr, "Error fseccomp: cannot open %s file\n", fname);
		exit(1);
	}

	size_t written = 0;
	while (written < size) {
		ssize_t rv = write(dst, (unsigned char *) filter + written, size - written);
		if (rv == -1) {
			fprintf(stderr, "Error fseccomp: cannot write %s file\n", fname);
			exit(1);
		}
		written += rv;
	}
	close(dst);
}


// 32 bit arch filter installed on 64 bit architectures
void seccomp_secondary_32(const char *fname) {
	// hardcoded syscall values
	struct sock_filter filter[] = {
		VALIDATE_ARCHITECTURE_32,
		EXAMINE_SYSCALL,
		BLACKLIST(21), // mount
		BLACKLIST(52), // umount2
// todo: implement --allow-debuggers
		BLACKLIST(26), // ptrace
		BLACKLIST(283), // kexec_load
		BLACKLIST(341), // name_to_handle_at
		BLACKLIST(342), // open_by_handle_at
		BLACKLIST(127), // create_module
		BLACKLIST(128), // init_module
		BLACKLIST(350), // finit_module
		BLACKLIST(129), // delete_module
		BLACKLIST(110), // iopl
		BLACKLIST(101), // ioperm
		BLACKLIST(289), // ioprio_set
		BLACKLIST(87), // swapon
		BLACKLIST(115), // swapoff
		BLACKLIST(103), // syslog
		BLACKLIST(347), // process_vm_readv
		BLACKLIST(348), // process_vm_writev
		BLACKLIST(135), // sysfs
		BLACKLIST(149), // _sysctl
		BLACKLIST(124), // adjtimex
		BLACKLIST(343), // clock_adjtime
		BLACKLIST(253), // lookup_dcookie
		BLACKLIST(336), // perf_event_open
		BLACKLIST(338), // fanotify_init
		BLACKLIST(349), // kcmp
		BLACKLIST(286), // add_key
		BLACKLIST(287), // request_key
		BLACKLIST(288), // keyctl
		BLACKLIST(86), // uselib
		BLACKLIST(51), // acct
		BLACKLIST(123), // modify_ldt
		BLACKLIST(217), // pivot_root
		BLACKLIST(245), // io_setup
		BLACKLIST(246), // io_destroy
		BLACKLIST(247), // io_getevents
		BLACKLIST(248), // io_submit
		BLACKLIST(249), // io_cancel
		BLACKLIST(257), // remap_file_pages
		BLACKLIST(274), // mbind
// breaking Firefox nightly when playing youtube videos
// TODO: test again when firefox sandbox is finally released
//		BLACKLIST(275), // get_mempolicy
		BLACKLIST(276), // set_mempolicy
		BLACKLIST(294), // migrate_pages
		BLACKLIST(317), // move_pages
		BLACKLIST(316), // vmsplice
		BLACKLIST(61),  // chroot
		BLACKLIST(88), // reboot
		BLACKLIST(169), // nfsservctl
		BLACKLIST(130), // get_kernel_syms

		RETURN_ALLOW
	};

	// save filter to file
	write_filter(fname, sizeof(filter), filter);
}

#define jmp_from_to(from_addr, to_addr) ((to_addr) - (from_addr) - 1)

#if __BYTE_ORDER == __BIG_ENDIAN
#define MSW 0
#define LSW (sizeof(int))
#else
#define MSW (sizeof(int))
#define LSW 0
#endif

void seccomp_secondary_block(const char *fname) {
	struct sock_filter filter[] = {
		// block other architectures
		VALIDATE_ARCHITECTURE_KILL,
		EXAMINE_SYSCALL,
#if defined(__x86_64__)
		// block x32
		HANDLE_X32,
#endif
		// block personality(2) where domain != PER_LINUX or 0xffffffff (query current personality)
		// 0: if  personality(2), continue to 1, else goto 7 (allow)
		BPF_JUMP(BPF_JMP + BPF_JEQ + BPF_K, SYS_personality, 0, jmp_from_to(0, 7)),
		// 1: get LSW of system call argument 0
		BPF_STMT(BPF_LD + BPF_W + BPF_ABS, (offsetof(struct seccomp_data, args[0])) + LSW),
		// 2: if LSW(arg0) == PER_LINUX, goto step 4, else continue to 3
		BPF_JUMP(BPF_JMP + BPF_JEQ + BPF_K, PER_LINUX, jmp_from_to(2, 4), 0),
		// 3: if LSW(arg0) == 0xffffffff, continue to 4, else goto 6 (kill)
		BPF_JUMP(BPF_JMP + BPF_JEQ + BPF_K, 0xffffffff, 0, jmp_from_to(3, 6)),
		// 4: get MSW of system call argument 0
		BPF_STMT(BPF_LD + BPF_W + BPF_ABS, (offsetof(struct seccomp_data, args[0])) + MSW),
		// 5: if MSW(arg0) == 0, goto 7 (allow) else continue to 6 (kill)
		BPF_JUMP(BPF_JMP + BPF_JEQ + BPF_K, 0, jmp_from_to(5, 7), 0),
		// 6:
		KILL_OR_RETURN_ERRNO,
		// 7:
		RETURN_ALLOW
	};

	// save filter to file
	write_filter(fname, sizeof(filter), filter);
}
