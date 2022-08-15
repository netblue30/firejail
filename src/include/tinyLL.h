extern int landlock_create_ruleset(struct landlock_ruleset_attr *rsattr,size_t size,__u32 flags);

extern int landlock_add_rule(int fd,enum landlock_rule_type t,void *attr,__u32 flags);

extern int landlock_restrict_self(int fd,__u32 flags);

extern int create_full_ruleset();

extern int add_read_access_rule(int rset_fd,int allowed_fd);

extern int add_read_access_rule_by_path(int rset_fd,char *allowed_path);

extern int add_write_access_rule(int rset_fd,int allowed_fd,int restricted);

extern int add_write_access_rule_by_path(int rset_fd,char *allowed_path,int restricted);

extern int add_execute_rule(int rset_fd,int allowed_fd);

extern int add_execute_rule_by_path(int rset_fd,char *allowed_path);

extern int check_nnp();

extern int enable_nnp();
