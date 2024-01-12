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
#include "firemon.h"
#include "../include/gcov_wrapper.h"
#include <sys/socket.h>
#include <linux/connector.h>
#include <linux/netlink.h>
#include <linux/cn_proc.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <time.h>
#include <fcntl.h>
#include <sys/uio.h>

#define PIDS_BUFLEN 4096
#define SERVER_PORT 889	// 889-899 is left unassigned by IANA

//#define DEBUG_PRCTL

static int pid_is_firejail(pid_t pid) {
#ifdef DEBUG_PRCTL
	printf("%s: %d, pid %d\n", __FUNCTION__, __LINE__, pid);
#endif
	uid_t rv = 0;

	// open /proc/self/comm
	char *file;
	if (asprintf(&file, "/proc/%u/comm", pid) == -1)
		errExit("asprintf");

	FILE *fp = fopen(file, "r");
	if (!fp) {
		free(file);
		return 0;
	}

	// look for firejail executable name
	char buf[PIDS_BUFLEN];
	if (fgets(buf, PIDS_BUFLEN - 1, fp)) {
		if (strncmp(buf, "firejail", 8) == 0)
			rv = 1;
	}

#ifdef DEBUG_PRCTL
	printf("%s: %d, comm %s, rv %d\n", __FUNCTION__, __LINE__, buf, rv);
#endif
	if (rv) {
		// open /proc/pid/cmdline file
		char *fname;
		int fd;
		if (asprintf(&fname, "/proc/%d/cmdline", pid) == -1)
			errExit("asprintf");
		if ((fd = open(fname, O_RDONLY)) < 0) {
			free(fname);
#ifdef DEBUG_PRCTL
			printf("%s: %d, comm %s, rv %d\n", __FUNCTION__, __LINE__, buf, rv);
#endif
			goto doexit;
		}
		free(fname);

		// read file
#define BUFLEN 4096
		unsigned char buffer[BUFLEN];
		ssize_t len;
		if ((len = read(fd, buffer, sizeof(buffer) - 1)) <= 0) {
			close(fd);
#ifdef DEBUG_PRCTL
			printf("%s: %d, comm %s, rv %d\n", __FUNCTION__, __LINE__, buf, rv);
#endif
			goto doexit;
		}
		buffer[len] = '\0';
		close(fd);

		// list of firejail arguments that don't trigger sandbox creation
		// the initial -- is not included
		char *exclude_args[] = {
			// all print options
			"apparmor.print", "caps.print", "cpu.print", "dns.print", "fs.print", "netfilter.print",
			"netfilter6.print", "profile.print", "protocol.print", "seccomp.print",
			// debug
			"debug-caps", "debug-errnos", "debug-protocols", "debug-syscalls", "debug-syscalls32",
			// file transfer
			"ls", "get", "put", "cat",
			// stats
			"tree", "list", "top",
			// network
			"netstats", "bandwidth",
			// etc
			"help", "version", "overlay-clean",

			NULL // end of list marker
		};

		int i;
		char *start;
		int first = 1;
		for (i = 0; i < len; i++) {
			if (buffer[i] != '\0')
				continue;
			if (first) {
				first = 0;
				start = (char *) buffer + i + 1;
				continue;
			}
			if (strncmp(start, "--", 2) != 0)
				break;
			start += 2;

			// clan starting with =
			char *ptr = strchr(start, '=');
			if (ptr)
				*ptr = '\0';

			// look into exclude list
			int j = 0;
			while (exclude_args[j] != NULL) {
				if (strcmp(start, exclude_args[j]) == 0) {
					rv = 0;
#ifdef DEBUG_PRCTL
printf("start=#%s#,  ptr=#%s#, flip rv %d\n", start, ptr, rv);
#endif
					break;
				}
				j++;
			}

			start = (char *) buffer + i + 1;
		}
	}

doexit:
	fclose(fp);
	free(file);
#ifdef DEBUG_PRCTL
	printf("%s: %d: return %d\n", __FUNCTION__, __LINE__, rv);
#endif
	return rv;
}


static int procevent_netlink_setup(void) {
	// open socket for process event connector
	int sock;
	if ((sock = socket(PF_NETLINK, SOCK_DGRAM, NETLINK_CONNECTOR)) < 0)
		goto errexit;

	// bind socket
	struct sockaddr_nl addr;
	memset(&addr, 0, sizeof(addr));
	addr.nl_pid = getpid();
	addr.nl_family = AF_NETLINK;
	addr.nl_groups = CN_IDX_PROC;
	if (bind(sock, (struct sockaddr *)&addr, sizeof(addr)) < 0)
		goto errexit;

	// set a large socket rx buffer
	// the regular default value as set in /proc/sys/net/core/rmem_default will fill the
	//            buffer much quicker than we can process it
	int bsize = 1024 * 1024; // 1MB
	socklen_t blen = sizeof(int);
	if (setsockopt(sock, SOL_SOCKET, SO_RCVBUFFORCE, &bsize, blen) == -1)
		fprintf(stderr, "Warning: cannot set rx buffer size, using default system value\n");
	else if (arg_debug) {
		if (getsockopt(sock, SOL_SOCKET, SO_RCVBUF, &bsize, &blen) == -1)
			fprintf(stderr, "Error: cannot read rx buffer size\n");
		else
			printf("rx buffer size %d\n", bsize / 2); // the value returned is double the real one, see man 7 socket
	}

	// send monitoring message
	struct nlmsghdr nlmsghdr;
	memset(&nlmsghdr, 0, sizeof(nlmsghdr));
	nlmsghdr.nlmsg_len = NLMSG_LENGTH(sizeof(struct cn_msg) + sizeof(enum proc_cn_mcast_op));
	nlmsghdr.nlmsg_pid = getpid();
	nlmsghdr.nlmsg_type = NLMSG_DONE;

	struct cn_msg cn_msg;
	memset(&cn_msg, 0, sizeof(cn_msg));
	cn_msg.id.idx = CN_IDX_PROC;
	cn_msg.id.val = CN_VAL_PROC;
	cn_msg.len = sizeof(enum proc_cn_mcast_op);

	struct iovec iov[3];
	iov[0].iov_base = &nlmsghdr;
	iov[0].iov_len = sizeof(nlmsghdr);
	iov[1].iov_base = &cn_msg;
	iov[1].iov_len = sizeof(cn_msg);

	enum proc_cn_mcast_op op = PROC_CN_MCAST_LISTEN;
	iov[2].iov_base = &op;
	iov[2].iov_len = sizeof(op);

	if (writev(sock, iov, 3) == -1)
		goto errexit;

	return sock;
errexit:
	fprintf(stderr, "Error: netlink socket problem\n");
	exit(1);
}


static void __attribute__((noreturn)) procevent_monitor(const int sock, pid_t mypid) {
	ssize_t len;
	struct nlmsghdr *nlmsghdr;

	// timeout in order to re-enable firejail module trace
	struct timeval tv;
	tv.tv_sec = 30;
	tv.tv_usec = 0;

	while (1) {
		__gcov_flush();

#define BUFFSIZE 4096
		char __attribute__ ((aligned(NLMSG_ALIGNTO)))buf[BUFFSIZE];

		fd_set readfds;
		int max;
		FD_ZERO(&readfds);
		FD_SET(sock, &readfds);
		max = sock;
		max++;

		int rv = select(max, &readfds, NULL, NULL, &tv);
		if (rv == -1) {
			errExit("recv");
		}

		// timeout
		if (rv == 0) {
			tv.tv_sec = 30;
			tv.tv_usec = 0;
			continue;
		}


		if ((len = recv(sock, buf, sizeof(buf), 0)) == 0)
			exit(0);
		if (len == -1) {
			if (errno == EINTR)
				continue;
			else if (errno == ENOBUFS) {
				// rx buffer is full, the kernel started dropping messages
				printf("*** Waning *** - message burst received, not all events are printed\n");
//return -1;
				continue;
			}
			else {
				fprintf(stderr,"Error: rx socket recv call, errno %d, %s\n", errno, strerror(errno));
				exit(1);
			}
		}

		for (nlmsghdr = (struct nlmsghdr *)buf;
			NLMSG_OK (nlmsghdr, (unsigned) len);
			nlmsghdr = NLMSG_NEXT (nlmsghdr, len)) {

			struct cn_msg *cn_msg;
			struct proc_event *proc_ev;
			struct tm tm;
			time_t now;

			if ((nlmsghdr->nlmsg_type == NLMSG_ERROR) ||
			    (nlmsghdr->nlmsg_type == NLMSG_NOOP))
				continue;

			cn_msg = NLMSG_DATA(nlmsghdr);
			if ((cn_msg->id.idx != CN_IDX_PROC) ||
			    (cn_msg->id.val != CN_VAL_PROC))
				continue;

			(void)time(&now);
			(void)localtime_r(&now, &tm);
			char line[PIDS_BUFLEN];
			char *lineptr = line;
			sprintf(lineptr, "%2.2d:%2.2d:%2.2d", tm.tm_hour, tm.tm_min, tm.tm_sec);
			lineptr += strlen(lineptr);

			proc_ev = (struct proc_event *)cn_msg->data;
			pid_t pid = 0;
			pid_t child = 0;
			int remove_pid = 0;
			switch (proc_ev->what) {
				case PROC_EVENT_FORK:
#ifdef DEBUG_PRCTL
	printf("%s: %d, event fork\n", __FUNCTION__, __LINE__);
#endif
					if (proc_ev->event_data.fork.child_pid !=
					    proc_ev->event_data.fork.child_tgid)
						continue; // this is a thread, not a process
					pid = proc_ev->event_data.fork.parent_tgid;
#ifdef DEBUG_PRCTL
	printf("%s: %d, event fork, pid %d\n", __FUNCTION__, __LINE__, pid);
#endif
					if (pids[pid].level > 0) {
						child = proc_ev->event_data.fork.child_tgid;
						child %= max_pids;
						pids[child].level = pids[pid].level + 1;
						pids[child].uid = pid_get_uid(child);
						pids[child].parent = pid;
					}
					sprintf(lineptr, " fork");
					break;
				case PROC_EVENT_EXEC:
					pid = proc_ev->event_data.exec.process_tgid;
#ifdef DEBUG_PRCTL
	printf("%s: %d, event exec, pid %d\n", __FUNCTION__, __LINE__, pid);
#endif
					if (pids[pid].level == -1) {
						pids[pid].level = 0; // start tracking
					}
					sprintf(lineptr, " exec");
					break;

				case PROC_EVENT_EXIT:
					if (proc_ev->event_data.exit.process_pid !=
					    proc_ev->event_data.exit.process_tgid)
						continue; // this is a thread, not a process

					pid = proc_ev->event_data.exit.process_tgid;
#ifdef DEBUG_PRCTL
	printf("%s: %d, event exit, pid %d\n", __FUNCTION__, __LINE__, pid);
#endif
					remove_pid = 1;
					sprintf(lineptr, " exit");
					break;



				case PROC_EVENT_UID:
					pid = proc_ev->event_data.id.process_tgid;
#ifdef DEBUG_PRCTL
	printf("%s: %d, event uid, pid %d\n", __FUNCTION__, __LINE__, pid);
#endif
					if (pids[pid].level == 1 ||
					    pids[pids[pid].parent].level == 1) {
						sprintf(lineptr, "\n");
						continue;
					}
					else
						sprintf(lineptr, " uid (%d:%d)",
							proc_ev->event_data.id.r.ruid,
							proc_ev->event_data.id.e.euid);
					break;

				case PROC_EVENT_GID:
					pid = proc_ev->event_data.id.process_tgid;
#ifdef DEBUG_PRCTL
	printf("%s: %d, event gid, pid %d\n", __FUNCTION__, __LINE__, pid);
#endif
					if (pids[pid].level == 1 ||
					    pids[pids[pid].parent].level == 1) {
						sprintf(lineptr, "\n");
						continue;
					}
					else
						sprintf(lineptr, " gid (%d:%d)",
							proc_ev->event_data.id.r.rgid,
							proc_ev->event_data.id.e.egid);
					break;



				case PROC_EVENT_SID:
					pid = proc_ev->event_data.sid.process_tgid;
#ifdef DEBUG_PRCTL
	printf("%s: %d, event sid, pid %d\n", __FUNCTION__, __LINE__, pid);
#endif
					sprintf(lineptr, " sid ");
					break;

				default:
#ifdef DEBUG_PRCTL
	printf("%s: %d, event unknown\n", __FUNCTION__, __LINE__);
#endif
					sprintf(lineptr, "\n");
					continue;
			}

			int add_new = 0;
			if (pids[pid].level < 0)	// not a firejail process
				continue;
			else if (pids[pid].level == 0) { // new process, do we track it?
				if (pid_is_firejail(pid) && mypid == 0) {
					pids[pid].level = 1;
					add_new = 1;
				}
				else {
					pids[pid].level = -1;
					continue;
				}
			}

			lineptr += strlen(lineptr);
			sprintf(lineptr, " %u", pid);
			lineptr += strlen(lineptr);

			char *user = pids[pid].option.event.user;
			if (!user)
				user = pid_get_user_name(pids[pid].uid);
			if (user) {
				pids[pid].option.event.user = user;
				sprintf(lineptr, " (%s)", user);
				lineptr += strlen(lineptr);
			}


			int sandbox_closed = 0; // exit sandbox flag
			char *cmd = pids[pid].option.event.cmd;
			if (!cmd) {
				cmd = pid_proc_cmdline(pid);
			}
			if (add_new) {
				if (!cmd)
					sprintf(lineptr, " NEW SANDBOX\n");
				else
					sprintf(lineptr, " NEW SANDBOX: %s\n", cmd);
				lineptr += strlen(lineptr);
			}
			else if (proc_ev->what == PROC_EVENT_EXIT && pids[pid].level == 1) {
				sprintf(lineptr, " EXIT SANDBOX\n");
				lineptr += strlen(lineptr);
				if (mypid == pid)
					sandbox_closed = 1;
			}
			else {
				if (!cmd) {
					cmd = pid_proc_cmdline(pid);
				}
				if (cmd == NULL)
					sprintf(lineptr, "\n");
				else {
					sprintf(lineptr, " %s\n", cmd);
					free(cmd);
				}
				lineptr += strlen(lineptr);
			}
			(void) lineptr;

			// print the event
			printf("%s", line);
			fflush(0);

			// unflag pid for exit events
			if (remove_pid) {
				if (pids[pid].option.event.user)
					free(pids[pid].option.event.user);
				if (pids[pid].option.event.cmd)
					free(pids[pid].option.event.cmd);
				memset(&pids[pid], 0, sizeof(Process));
			}

			// print forked child
			if (child) {
				cmd = pid_proc_cmdline(child);
				if (cmd) {
					printf("\tchild %u %s\n", child, cmd);
					free(cmd);
				}
				else
					printf("\tchild %u\n", child);
			}

			// on uid events the uid is changing
			if (proc_ev->what == PROC_EVENT_UID) {
				if (pids[pid].option.event.user)
					free(pids[pid].option.event.user);
				pids[pid].option.event.user = 0;
				pids[pid].uid = pid_get_uid(pid);
			}

			if (sandbox_closed)
				exit(0);
		}
	}
	__builtin_unreachable();
}

void procevent(pid_t pid) {
	// need to be root for this
	if (getuid() != 0) {
		fprintf(stderr, "Error: you need to be root to get process events\n");
		exit(1);
	}

	// set max_pids to the max value allowed by the kernel
	FILE *fp = fopen("/proc/sys/kernel/pid_max", "r");
	if (fp) {
		int val;
		if (fscanf(fp, "%d", &val) == 1) {
			if (val >= max_pids)
				max_pids = val + 1;
		}
		fclose(fp);
	}

	// monitor using netlink
	int sock = procevent_netlink_setup();
	if (sock < 0) {
		fprintf(stderr, "Error: cannot open netlink socket\n");
		exit(1);
	}

	procevent_monitor(sock, pid); // it will never return from here
}
