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

/* default seccomp filter
	// seccomp
	struct sock_filter filter[] = {
		VALIDATE_ARCHITECTURE,
		EXAMINE_SYSCALL,
		BLACKLIST(SYS_mount),  // mount/unmount filesystems
		BLACKLIST(SYS_umount2),
		BLACKLIST(SYS_ptrace), // trace processes
		BLACKLIST(SYS_kexec_load), // loading a different kernel
		BLACKLIST(SYS_open_by_handle_at), // open by handle
		BLACKLIST(SYS_init_module), // kernel module handling
		BLACKLIST(SYS_finit_module),
		BLACKLIST(SYS_delete_module),
		BLACKLIST(SYS_iopl), // io permissions
		BLACKLIST(SYS_ioperm),
		BLACKLIST(SYS_iopl), // io permissions
		BLACKLIST(SYS_ni_syscall),
		BLACKLIST(SYS_swapon), // swap on/off
		BLACKLIST(SYS_swapoff),
		BLACKLIST(SYS_syslog), // kernel printk control
		RETURN_ALLOW
	};

	struct sock_fprog prog = {
		.len = (unsigned short)(sizeof(filter) / sizeof(filter[0])),
		.filter = filter,
	};


	if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
		perror("prctl(NO_NEW_PRIVS)");
		return 1;
	}
	if (prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog)) {
		perror("prctl");
		return 1;
	}
*/

#ifndef SECCOMP_H
#define SECCOMP_H
#include <errno.h>
#include <linux/filter.h>
#include <sys/syscall.h>
#include <linux/capability.h>
#include <linux/audit.h>
#include <sys/stat.h>
#include <fcntl.h>

// From /usr/include/linux/filter.h
//struct sock_filter {	/* Filter block */
//	__u16	code;   /* Actual filter code */
//	__u8	jt;	/* Jump true */
//	__u8	jf;	/* Jump false */
//	__u32	k;      /* Generic multiuse field */
//};

// for old platforms (Debian "wheezy", etc.)
#ifndef BPF_MOD
#define BPF_MOD 0x90
#endif
#ifndef BPF_XOR
#define BPF_XOR 0xa0
#endif
#ifndef SECCOMP_RET_ACTION
#define SECCOMP_RET_ACTION 0x7fff0000U
#endif
#ifndef SECCOMP_RET_TRACE
#define SECCOMP_RET_TRACE 0x7ff00000U
#endif



#include <sys/prctl.h>
#ifndef PR_SET_NO_NEW_PRIVS
# define PR_SET_NO_NEW_PRIVS 38
#endif

#include <linux/seccomp.h>
#ifndef SECCOMP_RET_LOG
#define SECCOMP_RET_LOG		0x7ffc0000U
#endif


#if defined(__i386__)
# define ARCH_NR	AUDIT_ARCH_I386
# define ARCH_32	AUDIT_ARCH_I386
# define ARCH_64	AUDIT_ARCH_X86_64
#elif defined(__x86_64__)
# define ARCH_NR	AUDIT_ARCH_X86_64
# define ARCH_32	AUDIT_ARCH_I386
# define ARCH_64	AUDIT_ARCH_X86_64
#elif defined(__aarch64__)
# define ARCH_NR	AUDIT_ARCH_AARCH64
# define ARCH_32	AUDIT_ARCH_ARM
# define ARCH_64	AUDIT_ARCH_AARCH64
#elif defined(__arm__)
# define ARCH_NR	AUDIT_ARCH_ARM
# define ARCH_32	AUDIT_ARCH_ARM
# define ARCH_64	AUDIT_ARCH_AARCH64
#elif defined(__mips__) && __BYTE_ORDER == __BIG_ENDIAN && _MIPS_SIM == _MIPS_SIM_ABI32
# define ARCH_NR	AUDIT_ARCH_MIPS
# define ARCH_32	AUDIT_ARCH_MIPS
# define ARCH_64	AUDIT_ARCH_MIPS64
#elif defined(__mips__) && __BYTE_ORDER == __LITTLE_ENDIAN && _MIPS_SIM == _MIPS_SIM_ABI32
# define ARCH_NR	AUDIT_ARCH_MIPSEL
# define ARCH_32	AUDIT_ARCH_MIPSEL
# define ARCH_64	AUDIT_ARCH_MIPSEL64
#elif defined(__mips__) && __BYTE_ORDER == __BIG_ENDIAN && _MIPS_SIM == _MIPS_SIM_ABI64
# define ARCH_NR	AUDIT_ARCH_MIPS64
# define ARCH_32	AUDIT_ARCH_MIPS
# define ARCH_64	AUDIT_ARCH_MIPS64
#elif defined(__mips__) && __BYTE_ORDER == __LITTLE_ENDIAN && _MIPS_SIM == _MIPS_SIM_ABI64
# define ARCH_NR	AUDIT_ARCH_MIPSEL64
# define ARCH_32	AUDIT_ARCH_MIPSEL
# define ARCH_64	AUDIT_ARCH_MIPSEL64
#elif defined(__mips__) && __BYTE_ORDER == __BIG_ENDIAN && _MIPS_SIM == _MIPS_SIM_NABI32
# define ARCH_NR	AUDIT_ARCH_MIPS64N32
# define ARCH_32	AUDIT_ARCH_MIPS64N32
# define ARCH_64	AUDIT_ARCH_MIPS64
#elif defined(__mips__) && __BYTE_ORDER == __LITTLE_ENDIAN && _MIPS_SIM == _MIPS_SIM_NABI32
# define ARCH_NR	AUDIT_ARCH_MIPSEL64N32
# define ARCH_32	AUDIT_ARCH_MIPSEL64N32
# define ARCH_64	AUDIT_ARCH_MIPSEL64
#elif defined(__powerpc64__) && __BYTE_ORDER == __BIG_ENDIAN
# define ARCH_NR	AUDIT_ARCH_PPC64
# define ARCH_32	AUDIT_ARCH_PPC
# define ARCH_64	AUDIT_ARCH_PPC64
#elif defined(__powerpc64__) && __BYTE_ORDER == __LITTLE_ENDIAN
# define ARCH_NR	AUDIT_ARCH_PPC64LE
# define ARCH_32	AUDIT_ARCH_PPC
# define ARCH_64	AUDIT_ARCH_PPC64LE
#elif defined(__powerpc__)
# define ARCH_NR	AUDIT_ARCH_PPC
# define ARCH_32	AUDIT_ARCH_PPC
# define ARCH_64	AUDIT_ARCH_PPC64LE
#elif defined(__s390x__)
# define ARCH_NR	AUDIT_ARCH_S390X
# define ARCH_32	AUDIT_ARCH_S390
# define ARCH_64	AUDIT_ARCH_S390X
#elif defined(__s390__)
# define ARCH_NR	AUDIT_ARCH_S390
# define ARCH_32	AUDIT_ARCH_S390
# define ARCH_64	AUDIT_ARCH_S390X
#elif defined(__sh64__) && __BYTE_ORDER == __BIG_ENDIAN
# define ARCH_NR	AUDIT_ARCH_SH64
# define ARCH_32	AUDIT_ARCH_SH
# define ARCH_64	AUDIT_ARCH_SH64
#elif defined(__sh64__) && __BYTE_ORDER == __LITTLE_ENDIAN
# define ARCH_NR	AUDIT_ARCH_SHEL64
# define ARCH_32	AUDIT_ARCH_SHEL
# define ARCH_64	AUDIT_ARCH_SHEL64
#elif defined(__sh__) && __BYTE_ORDER == __BIG_ENDIAN
# define ARCH_NR	AUDIT_ARCH_SH
# define ARCH_32	AUDIT_ARCH_SH
# define ARCH_64	AUDIT_ARCH_SH64
#elif defined(__sh__) && __BYTE_ORDER == __LITTLE_ENDIAN
# define ARCH_NR	AUDIT_ARCH_SHEL
# define ARCH_32	AUDIT_ARCH_SHEL
# define ARCH_64	AUDIT_ARCH_SHEL64
#elif defined(__sparc64__)
# define ARCH_NR	AUDIT_ARCH_SPARC64
# define ARCH_32	AUDIT_ARCH_SPARC
# define ARCH_64	AUDIT_ARCH_SPARC64
#elif defined(__sparc__)
# define ARCH_NR	AUDIT_ARCH_SPARC
# define ARCH_32	AUDIT_ARCH_SPARC
# define ARCH_64	AUDIT_ARCH_SPARC64
#else
# warning "Platform does not support seccomp filter yet"
# define ARCH_NR	0
# define ARCH_32	0
# define ARCH_64	0
#endif

#define VALIDATE_ARCHITECTURE \
	BPF_STMT(BPF_LD+BPF_W+BPF_ABS, (offsetof(struct seccomp_data, arch))), \
	BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, ARCH_NR, 1, 0), \
	BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_ALLOW)

#define VALIDATE_ARCHITECTURE_KILL \
	BPF_STMT(BPF_LD+BPF_W+BPF_ABS, (offsetof(struct seccomp_data, arch))), \
	BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, ARCH_NR, 1, 0), \
	KILL_OR_RETURN_ERRNO

#define VALIDATE_ARCHITECTURE_64 \
	BPF_STMT(BPF_LD+BPF_W+BPF_ABS, (offsetof(struct seccomp_data, arch))), \
	BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, ARCH_64, 1, 0), \
	BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_ALLOW)

#define VALIDATE_ARCHITECTURE_32 \
	BPF_STMT(BPF_LD+BPF_W+BPF_ABS, (offsetof(struct seccomp_data, arch))), \
	BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, ARCH_32, 1, 0), \
	BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_ALLOW)

#ifndef X32_SYSCALL_BIT
#define X32_SYSCALL_BIT 0x40000000
#endif

#if defined(__x86_64__)
// handle X32 ABI
#define HANDLE_X32 \
		BPF_JUMP(BPF_JMP+BPF_JGE+BPF_K, X32_SYSCALL_BIT, 1, 0), \
		BPF_JUMP(BPF_JMP+BPF_JGE+BPF_K, 0, 1, 0), \
		KILL_OR_RETURN_ERRNO
#endif

#define EXAMINE_SYSCALL BPF_STMT(BPF_LD+BPF_W+BPF_ABS,	\
		 (offsetof(struct seccomp_data, nr)))

#define EXAMINE_ARGUMENT(nr) BPF_STMT(BPF_LD+BPF_W+BPF_ABS,	\
		 (offsetof(struct seccomp_data, args[nr])))

#define ONLY(syscall_nr)	\
	BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, syscall_nr, 1, 0),	\
	BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_ALLOW)

#define BLACKLIST(syscall_nr)	\
	BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, syscall_nr, 0, 1),	\
	KILL_OR_RETURN_ERRNO

#define WHITELIST(syscall_nr) \
	BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, syscall_nr, 0, 1), \
	BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_ALLOW)

#define BLACKLIST_ERRNO(syscall_nr, nr) \
	BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, syscall_nr, 0, 1), \
	BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_ERRNO | nr)

#define RETURN_ALLOW \
	BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_ALLOW)

#define RETURN_KILL \
	BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_KILL)

#define RETURN_ERRNO(nr) \
	BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_ERRNO | nr)

extern int arg_seccomp_error_action;	// error action: errno, log or kill
#define DEFAULT_SECCOMP_ERROR_ACTION EPERM

#define KILL_OR_RETURN_ERRNO \
	BPF_STMT(BPF_RET+BPF_K, arg_seccomp_error_action)

#endif
