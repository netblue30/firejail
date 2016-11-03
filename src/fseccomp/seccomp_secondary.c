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
#include "fseccomp.h"
#include "../include/seccomp.h"
#include <sys/syscall.h>

void seccomp_secondary_64(const char *fname) {
	// hardcoded syscall values
	struct sock_filter filter[] = {
		VALIDATE_ARCHITECTURE_64,
		EXAMINE_SYSCALL,
		BLACKLIST(165), // mount
		BLACKLIST(166), // umount2
// todo: implement --allow-debuggers		
		BLACKLIST(101), // ptrace
		BLACKLIST(246), // kexec_load
		BLACKLIST(304), // open_by_handle_at
		BLACKLIST(303), // name_to_handle_at
		BLACKLIST(174), // create_module
		BLACKLIST(175), // init_module
		BLACKLIST(313), // finit_module
		BLACKLIST(176), // delete_module
		BLACKLIST(172), // iopl
		BLACKLIST(173), // ioperm
		BLACKLIST(251), // ioprio_set
		BLACKLIST(167), // swapon
		BLACKLIST(168), // swapoff
		BLACKLIST(103), // syslog
		BLACKLIST(310), // process_vm_readv
		BLACKLIST(311), // process_vm_writev
		BLACKLIST(139), // sysfs
		BLACKLIST(156), // _sysctl
		BLACKLIST(159), // adjtimex
		BLACKLIST(305), // clock_adjtime
		BLACKLIST(212), // lookup_dcookie
		BLACKLIST(298), // perf_event_open
		BLACKLIST(300), // fanotify_init
		BLACKLIST(312), // kcmp
		BLACKLIST(248), // add_key
		BLACKLIST(249), // request_key
		BLACKLIST(250), // keyctl
		BLACKLIST(134), // uselib
		BLACKLIST(163), // acct
		BLACKLIST(154), // modify_ldt
		BLACKLIST(155), // pivot_root
		BLACKLIST(206), // io_setup
		BLACKLIST(207), // io_destroy
		BLACKLIST(208), // io_getevents
		BLACKLIST(209), // io_submit
		BLACKLIST(210), // io_cancel
		BLACKLIST(216), // remap_file_pages
		BLACKLIST(237), // mbind
		BLACKLIST(239), // get_mempolicy
		BLACKLIST(238), // set_mempolicy
		BLACKLIST(256), // migrate_pages
		BLACKLIST(279), // move_pages
		BLACKLIST(278), // vmsplice
		BLACKLIST(161), // chroot
		BLACKLIST(184), // tuxcall
		BLACKLIST(169), // reboot
		BLACKLIST(180), // nfsservctl
		BLACKLIST(177), // get_kernel_syms
		
		RETURN_ALLOW
	};

	// save filter to file
	int dst = open(fname, O_CREAT|O_WRONLY|O_TRUNC, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
	if (dst < 0) {
		fprintf(stderr, "Error fseccomp: cannot open %s file\n", fname);
		exit(1);
	}
	
	int size = (int) sizeof(filter);
	int written = 0;
	while (written < size) {
		int rv = write(dst, (unsigned char *) filter + written, size - written);
		if (rv == -1) {
			fprintf(stderr, "Error fseccomp: cannot write %s file\n", fname);
			exit(1);
		}
		written += rv;
	}
	close(dst);
}

// i386 filter installed on amd64 architectures
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
		BLACKLIST(275), // get_mempolicy
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
	int dst = open(fname, O_CREAT|O_WRONLY|O_TRUNC, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
	if (dst < 0) {
		fprintf(stderr, "Error fseccomp: cannot open %s file\n", fname);
		exit(1);
	}
	
	int size = (int) sizeof(filter);
	int written = 0;
	while (written < size) {
		int rv = write(dst, (unsigned char *) filter + written, size - written);
		if (rv == -1) {
			fprintf(stderr, "Error fseccomp: cannot write %s file\n", fname);
			exit(1);
		}
		written += rv;
	}
	close(dst);
}

