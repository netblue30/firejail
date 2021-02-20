#ifndef JAILTEST_H
#define JAILTEST_H

#include "../include/common.h"

// main.c
extern uid_t user_uid;
extern gid_t user_gid;
extern char *user_name;
extern char *user_home_dir;

// access.c
void access_setup(const char *directory);
void access_test(void);
void access_destroy(void);

// noexec.c
void noexec_setup(void);
void noexec_test(const char *msg);

// virtual.c
void virtual_setup(const char *directory);
void virtual_destroy(void);
void virtual_test(void);

// utils.c
char *get_sudo_user(void);
char *get_homedir(const char *user, uid_t *uid, gid_t *gid);
int find_child(pid_t parent, pid_t *child);
pid_t switch_to_child(pid_t pid);

#endif