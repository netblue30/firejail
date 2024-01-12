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
 *
 *
 *
 * Parts of this code was lifted from libseccomp project, license LGPL 2.1.
 * This is the original copyright notice in libseccomp code:
 *
 *
 *
 * BPF Disassembler
 *
 * Copyright (c) 2012 Red Hat <pmoore@redhat.com>
 * Author: Paul Moore <paul@paul-moore.com>
 *
 * This library is free software; you can redistribute it and/or modify it
 * under the terms of version 2.1 of the GNU Lesser General Public License as
 * published by the Free Software Foundation.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License
 * for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this library; if not, see <https://www.gnu.org/licenses>.
 */

#include "fsec_print.h"

// From /usr/include/linux/filter.h
//struct sock_filter {	/* Filter block */
//	__u16	code;   /* Actual filter code */
//	__u8	jt;	/* Jump true */
//	__u8	jf;	/* Jump false */
//	__u32	k;      /* Generic multiuse field */
//};


static const char *bpf_decode_op(const struct sock_filter *bpf) {
	switch (bpf->code) {
	case BPF_LD+BPF_W+BPF_IMM:
	case BPF_LD+BPF_W+BPF_ABS:
	case BPF_LD+BPF_W+BPF_IND:
	case BPF_LD+BPF_W+BPF_MEM:
	case BPF_LD+BPF_W+BPF_LEN:
	case BPF_LD+BPF_W+BPF_MSH:
		return "ld";
	case BPF_LD+BPF_H+BPF_IMM:
	case BPF_LD+BPF_H+BPF_ABS:
	case BPF_LD+BPF_H+BPF_IND:
	case BPF_LD+BPF_H+BPF_MEM:
	case BPF_LD+BPF_H+BPF_LEN:
	case BPF_LD+BPF_H+BPF_MSH:
		return "ldh";
	case BPF_LD+BPF_B+BPF_IMM:
	case BPF_LD+BPF_B+BPF_ABS:
	case BPF_LD+BPF_B+BPF_IND:
	case BPF_LD+BPF_B+BPF_MEM:
	case BPF_LD+BPF_B+BPF_LEN:
	case BPF_LD+BPF_B+BPF_MSH:
		return "ldb";
	case BPF_LDX+BPF_W+BPF_IMM:
	case BPF_LDX+BPF_W+BPF_ABS:
	case BPF_LDX+BPF_W+BPF_IND:
	case BPF_LDX+BPF_W+BPF_MEM:
	case BPF_LDX+BPF_W+BPF_LEN:
	case BPF_LDX+BPF_W+BPF_MSH:
	case BPF_LDX+BPF_H+BPF_IMM:
	case BPF_LDX+BPF_H+BPF_ABS:
	case BPF_LDX+BPF_H+BPF_IND:
	case BPF_LDX+BPF_H+BPF_MEM:
	case BPF_LDX+BPF_H+BPF_LEN:
	case BPF_LDX+BPF_H+BPF_MSH:
	case BPF_LDX+BPF_B+BPF_IMM:
	case BPF_LDX+BPF_B+BPF_ABS:
	case BPF_LDX+BPF_B+BPF_IND:
	case BPF_LDX+BPF_B+BPF_MEM:
	case BPF_LDX+BPF_B+BPF_LEN:
	case BPF_LDX+BPF_B+BPF_MSH:
		return "ldx";
	case BPF_ST:
		return "st";
	case BPF_STX:
		return "stx";
	case BPF_ALU+BPF_ADD+BPF_K:
	case BPF_ALU+BPF_ADD+BPF_X:
		return "add";
	case BPF_ALU+BPF_SUB+BPF_K:
	case BPF_ALU+BPF_SUB+BPF_X:
		return "sub";
	case BPF_ALU+BPF_MUL+BPF_K:
	case BPF_ALU+BPF_MUL+BPF_X:
		return "mul";
	case BPF_ALU+BPF_DIV+BPF_K:
	case BPF_ALU+BPF_DIV+BPF_X:
		return "div";
	case BPF_ALU+BPF_OR+BPF_K:
	case BPF_ALU+BPF_OR+BPF_X:
		return "or";
	case BPF_ALU+BPF_AND+BPF_K:
	case BPF_ALU+BPF_AND+BPF_X:
		return "and";
	case BPF_ALU+BPF_LSH+BPF_K:
	case BPF_ALU+BPF_LSH+BPF_X:
		return "lsh";
	case BPF_ALU+BPF_RSH+BPF_K:
	case BPF_ALU+BPF_RSH+BPF_X:
		return "rsh";
	case BPF_ALU+BPF_NEG+BPF_K:
	case BPF_ALU+BPF_NEG+BPF_X:
		return "neg";
	case BPF_ALU+BPF_MOD+BPF_K:
	case BPF_ALU+BPF_MOD+BPF_X:
		return "mod";
	case BPF_ALU+BPF_XOR+BPF_K:
	case BPF_ALU+BPF_XOR+BPF_X:
		return "xor";
	case BPF_JMP+BPF_JA+BPF_K:
	case BPF_JMP+BPF_JA+BPF_X:
		return "jmp";
	case BPF_JMP+BPF_JEQ+BPF_K:
	case BPF_JMP+BPF_JEQ+BPF_X:
		return "jeq";
	case BPF_JMP+BPF_JGT+BPF_K:
	case BPF_JMP+BPF_JGT+BPF_X:
		return "jgt";
	case BPF_JMP+BPF_JGE+BPF_K:
	case BPF_JMP+BPF_JGE+BPF_X:
		return "jge";
	case BPF_JMP+BPF_JSET+BPF_K:
	case BPF_JMP+BPF_JSET+BPF_X:
		return "jset";
	case BPF_RET+BPF_K:
	case BPF_RET+BPF_X:
	case BPF_RET+BPF_A:
		return "ret";
	case BPF_MISC+BPF_TAX:
		return "tax";
	case BPF_MISC+BPF_TXA:
		return "txa";
	}
	return "???";
}

static void bpf_decode_action(uint32_t k) {
	uint32_t act = k & SECCOMP_RET_ACTION;
	uint32_t data = k & SECCOMP_RET_DATA;

	switch (act) {
	case SECCOMP_RET_KILL:
		printf("KILL");
		break;
	case SECCOMP_RET_TRAP:
		printf("TRAP");
		break;
	case SECCOMP_RET_ERRNO:
		printf("ERRNO(%u)", data);
		break;
	case SECCOMP_RET_TRACE:
		printf("TRACE(%u)", data);
		break;
	case SECCOMP_RET_LOG:
		printf("LOG");
		break;
	case SECCOMP_RET_ALLOW:
		printf("ALLOW");
		break;
	default:
		printf("0x%.8x", k);
	}
}


// implementing a simple state machine around accumulator
// in order to translate the syscall number
int syscall_loaded = 0;
int native_arch = 0;

static void bpf_decode_args(const struct sock_filter *bpf, unsigned int line) {
	switch (BPF_CLASS(bpf->code)) {
	case BPF_LD:
	case BPF_LDX:
		switch (BPF_MODE(bpf->code)) {
		case BPF_ABS:
			syscall_loaded = 0;
			if (bpf->k == offsetof(struct seccomp_data, arch))
				printf("data.architecture");
			else if (bpf->k == offsetof(struct seccomp_data, nr)) {
				printf("data.syscall-number");
				syscall_loaded = 1;
			}
			else if (bpf->k == offsetof(struct seccomp_data, instruction_pointer))
				printf("data.instruction_pointer");
			else {
				int index = bpf->k - offsetof(struct seccomp_data, args);
				printf("data.args[%x]", index);
			}
			break;
		case BPF_MEM:
			printf("$temp[%u]", bpf->k);
			break;
		case BPF_IMM:
			printf("%x", bpf->k);
			break;
		case BPF_IND:
			printf("$data[X + %x]", bpf->k);
			break;
		case BPF_LEN:
			printf("len($data)");
			break;
		case BPF_MSH:
			printf("4 * $data[%x] & 0x0f", bpf->k);
			break;
		}
		break;
	case BPF_ST:
	case BPF_STX:
		printf("$temp[%u]", bpf->k);
		break;
	case BPF_ALU:
		if (BPF_SRC(bpf->code) == BPF_K) {
			switch (BPF_OP(bpf->code)) {
			case BPF_OR:
			case BPF_AND:
				printf("%.8x", bpf->k);
				break;
			default:
				printf("%x", bpf->k);
			}
		}
		else
			printf("%u", bpf->k);
		break;
	case BPF_JMP:
		if (BPF_OP(bpf->code) == BPF_JA) {
			printf("%.4x", (line + 1) + bpf->k);
		}
		else {
			const char *name = NULL;
			if (syscall_loaded && native_arch)
				name = syscall_find_nr(bpf->k);
			if (bpf->k == ARCH_32) {
				printf("ARCH_32 %.4x (false %.4x)",
				       (line + 1) + bpf->jt,
				       (line + 1) + bpf->jf);
				 native_arch = (ARCH_NR == ARCH_32)? 1: 0;
			}
			else if (bpf->k == ARCH_64) {
				printf("ARCH_64 %.4x (false %.4x)",
				       (line + 1) + bpf->jt,
				       (line + 1) + bpf->jf);
				 native_arch = (ARCH_NR == ARCH_64)? 1: 0;
			}
			else if (bpf->k == X32_SYSCALL_BIT)
				printf("X32_ABI %.4x (false %.4x)",
				       (line + 1) + bpf->jt,
				       (line + 1) + bpf->jf);
			else if (name)
				printf("%s %.4x (false %.4x)",
				       name,
				       (line + 1) + bpf->jt,
				       (line + 1) + bpf->jf);
			else
				printf("%x %.4x (false %.4x)",
				       bpf->k,
				       (line + 1) + bpf->jt,
				       (line + 1) + bpf->jf);
		}
		break;
	case BPF_RET:
		if (BPF_RVAL(bpf->code) == BPF_A) {
			/* XXX - accumulator? */
			printf("$acc");
		}
		else if (BPF_SRC(bpf->code) == BPF_K) {
			bpf_decode_action(bpf->k);
		}
		else if (BPF_SRC(bpf->code) == BPF_X) {
			/* XXX - any idea? */
			printf("???");
		}
		break;
	case BPF_MISC:
		break;
	default:
		printf("???");
	}
}

void print(struct sock_filter *filter, int entries) {
	int i;

	/* header */
	printf(" line  OP JT JF    K\n");
	printf("=================================\n");
	struct sock_filter *bpf = filter;
	for (i = 0; i < entries; i++, bpf++) {

		/* convert the bpf statement */
//		bpf.code = ttoh16(arch, bpf.code);
//		bpf.k = ttoh32(arch, bpf.k);

		/* display a hex dump */
		printf(" %.4x: %.2x %.2x %.2x %.8x",
		       i, bpf->code, bpf->jt, bpf->jf, bpf->k);

		/* display the assembler statements */
		printf("   ");
		printf("%-3s", bpf_decode_op(bpf));
		printf(" ");
		bpf_decode_args(bpf, i);

		printf("\n");
	}
}
