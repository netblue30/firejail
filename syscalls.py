#!/usr/bin/python3

from subprocess import run

FIREJAIL_GROUPS = {
    "@default": [
        "@clock",
        "@cpu-emulation",
        "@debug",
        "@module",
        "@mount",
        "@obsolete",
        "@raw-io",
        "@reboot",
        "@swap",
        "add_key",
        "bpf",
        "fanotify_init",
        "io_cancel",
        "io_destroyio_getevents",
        "io_setup",
        "io_submit",
        "ioprio_set",
        "kcmp",
        "keyctl",
        "mbind",
        "migrate_pagesmove_pages",
        "name_to_handle_at",
        "nfsservctl",
        "ni_syscall",
        "open_by_handle_at",
        "remap_file_pages",
        "request_key",
        "set_mempolicy",
        "setdomainname",
        "sethostname",
        "syslog",
        "userfaultfdacct",
        "vhangup",
        "vmsplice",
        #"mincore"
    ],
    "@default-nodebuggers": [
        "@default",
        "personality",
        "process_vm_readv",
        "ptrace",
    ],
    "@default-keep": [
        "execve",
        "prctl",
    ],
}

def fetch_systemd_groups():
    """Call `systemd-analyze syscall-filter` and parses its output.

    Returns:
        {"@GROUP1": ["SYSCALL1", "SYSCALL2", ...], "@GROUP2": ...}
    """
    systemd_groups = {}
    current_group = None
    for line in run(["systemd-analyze", "syscall-filter"], capture_output=True, check=True, text=True).stdout.splitlines():
        if not line:
            current_group = None
        elif line[0] == "#":
            continue
        elif line[0] == "@":
            if line == "@default":
                line = "@common"
            systemd_groups[line] = []
            current_group = line
        elif line.startswith("    #"):
            pass
        else:
            if line == "    @default":
                line = "@common"
            systemd_groups[current_group].append(line.strip())
    return systemd_groups

def write(groups):
    """"""
    c_lines = ["static const SyscallGroupList sysgroups[] = {"]
    for group in sorted(groups):
        c_lines.append('\t{ .name = "' + group + '", .list =')
        for syscall in groups[group]:
            if syscall[0] == "@":
                c_lines.append(f'\t  "{syscall},"')
            else:
                c_lines.append(f"#ifdef SYS_{syscall}")
                c_lines.append(f'\t  "{syscall},"')
                c_lines.append("#endif")
        c_lines.append("\t},")
    c_lines.append("};")
    print("\n".join(c_lines))

def main():
    groups = { **FIREJAIL_GROUPS, **fetch_systemd_groups() }
    for group in groups:
        groups[group].sort()
    write(groups)

if __name__ == "__main__":
    main()
