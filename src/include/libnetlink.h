/* file extracted from iproute2 software package
 *
 * Original source code:
 * 
 * Information:
 *     http://www.linuxfoundation.org/collaborate/workgroups/networking/iproute2
 * 
 * Download:
 *     http://www.kernel.org/pub/linux/utils/net/iproute2/
 * 
 * Repository:
 *     git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/iproute2.git
 * 
 * License: GPL v2
 */


#ifndef __LIBNETLINK_H__
#define __LIBNETLINK_H__ 1

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <asm/types.h>
#include <linux/netlink.h>
#include <linux/rtnetlink.h>
#include <linux/if_link.h>
#include <linux/if_addr.h>
#include <linux/neighbour.h>

struct rtnl_handle
{
	int			fd;
	struct sockaddr_nl	local;
	struct sockaddr_nl	peer;
	__u32			seq;
	__u32			dump;
};

extern int rcvbuf;

extern int rtnl_open(struct rtnl_handle *rth, unsigned subscriptions);
extern int rtnl_open_byproto(struct rtnl_handle *rth, unsigned subscriptions, int protocol);
extern void rtnl_close(struct rtnl_handle *rth);
extern int rtnl_wilddump_request(struct rtnl_handle *rth, int fam, int type);
extern int rtnl_wilddump_req_filter(struct rtnl_handle *rth, int fam, int type,
				    __u32 filt_mask);
extern int rtnl_dump_request(struct rtnl_handle *rth, int type, void *req, int len);

typedef int (*rtnl_filter_t)(const struct sockaddr_nl *,
			     struct nlmsghdr *n, void *);

struct rtnl_dump_filter_arg
{
	rtnl_filter_t filter;
	void *arg1;
};

extern int rtnl_dump_filter_l(struct rtnl_handle *rth,
			      const struct rtnl_dump_filter_arg *arg);
extern int rtnl_dump_filter(struct rtnl_handle *rth, rtnl_filter_t filter,
			    void *arg);
extern int rtnl_talk(struct rtnl_handle *rtnl, struct nlmsghdr *n, pid_t peer,
		     unsigned groups, struct nlmsghdr *answer);
extern int rtnl_send(struct rtnl_handle *rth, const void *buf, int);
extern int rtnl_send_check(struct rtnl_handle *rth, const void *buf, int);

extern int addattr(struct nlmsghdr *n, int maxlen, int type);
extern int addattr8(struct nlmsghdr *n, int maxlen, int type, __u8 data);
extern int addattr16(struct nlmsghdr *n, int maxlen, int type, __u16 data);
extern int addattr32(struct nlmsghdr *n, int maxlen, int type, __u32 data);
extern int addattr64(struct nlmsghdr *n, int maxlen, int type, __u64 data);
extern int addattrstrz(struct nlmsghdr *n, int maxlen, int type, const char *data);

extern int addattr_l(struct nlmsghdr *n, int maxlen, int type, const void *data, int alen);
extern int addraw_l(struct nlmsghdr *n, int maxlen, const void *data, int len);
extern struct rtattr *addattr_nest(struct nlmsghdr *n, int maxlen, int type);
extern int addattr_nest_end(struct nlmsghdr *n, struct rtattr *nest);
extern struct rtattr *addattr_nest_compat(struct nlmsghdr *n, int maxlen, int type, const void *data, int len);
extern int addattr_nest_compat_end(struct nlmsghdr *n, struct rtattr *nest);
extern int rta_addattr32(struct rtattr *rta, int maxlen, int type, __u32 data);
extern int rta_addattr_l(struct rtattr *rta, int maxlen, int type, const void *data, int alen);

extern int parse_rtattr(struct rtattr *tb[], int max, struct rtattr *rta, int len);
extern int parse_rtattr_flags(struct rtattr *tb[], int max, struct rtattr *rta,
			      int len, unsigned short flags);
extern int parse_rtattr_byindex(struct rtattr *tb[], int max, struct rtattr *rta, int len);
extern int __parse_rtattr_nested_compat(struct rtattr *tb[], int max, struct rtattr *rta, int len);

#define parse_rtattr_nested(tb, max, rta) \
	(parse_rtattr((tb), (max), RTA_DATA(rta), RTA_PAYLOAD(rta)))

#define parse_rtattr_nested_compat(tb, max, rta, data, len) \
	({ data = RTA_PAYLOAD(rta) >= len ? RTA_DATA(rta) : NULL;	\
		__parse_rtattr_nested_compat(tb, max, rta, len); })

static inline __u8 rta_getattr_u8(const struct rtattr *rta)
{
	return *(__u8 *)RTA_DATA(rta);
}
static inline __u16 rta_getattr_u16(const struct rtattr *rta)
{
	return *(__u16 *)RTA_DATA(rta);
}
static inline __u32 rta_getattr_u32(const struct rtattr *rta)
{
	return *(__u32 *)RTA_DATA(rta);
}
static inline __u64 rta_getattr_u64(const struct rtattr *rta)
{
	__u64 tmp;
	memcpy(&tmp, RTA_DATA(rta), sizeof(__u64));
	return tmp;
}
static inline const char *rta_getattr_str(const struct rtattr *rta)
{
	return (const char *)RTA_DATA(rta);
}

extern int rtnl_listen(struct rtnl_handle *, rtnl_filter_t handler,
		       void *jarg);
extern int rtnl_from_file(FILE *, rtnl_filter_t handler,
		       void *jarg);

#define NLMSG_TAIL(nmsg) \
	((struct rtattr *) (((void *) (nmsg)) + NLMSG_ALIGN((nmsg)->nlmsg_len)))

#ifndef IFA_RTA
#define IFA_RTA(r) \
	((struct rtattr*)(((char*)(r)) + NLMSG_ALIGN(sizeof(struct ifaddrmsg))))
#endif
#ifndef IFA_PAYLOAD
#define IFA_PAYLOAD(n)	NLMSG_PAYLOAD(n,sizeof(struct ifaddrmsg))
#endif

#ifndef IFLA_RTA
#define IFLA_RTA(r) \
	((struct rtattr*)(((char*)(r)) + NLMSG_ALIGN(sizeof(struct ifinfomsg))))
#endif
#ifndef IFLA_PAYLOAD
#define IFLA_PAYLOAD(n)	NLMSG_PAYLOAD(n,sizeof(struct ifinfomsg))
#endif

#ifndef NDA_RTA
#define NDA_RTA(r) \
	((struct rtattr*)(((char*)(r)) + NLMSG_ALIGN(sizeof(struct ndmsg))))
#endif
#ifndef NDA_PAYLOAD
#define NDA_PAYLOAD(n)	NLMSG_PAYLOAD(n,sizeof(struct ndmsg))
#endif

#ifndef NDTA_RTA
#define NDTA_RTA(r) \
	((struct rtattr*)(((char*)(r)) + NLMSG_ALIGN(sizeof(struct ndtmsg))))
#endif
#ifndef NDTA_PAYLOAD
#define NDTA_PAYLOAD(n) NLMSG_PAYLOAD(n,sizeof(struct ndtmsg))
#endif

#endif /* __LIBNETLINK_H__ */

