project('firejail', 'c',
  license: 'GPL-2.0-or-later',
  # https://packages.debian.org/oldstable/meson
  meson_version: '>=0.49.2',
  version: '0.9.67',
)

# # # # # # # #

PREFIX = get_option('prefix')
BINDIR = PREFIX / get_option('bindir')
SYSCONFDIR = PREFIX / get_option('sysconfdir')
LIBDIR = PREFIX / get_option('libdir')

constants = {
  'PREFIX': PREFIX,
  'BINDIR': BINDIR,
  'SYSCONFDIR': SYSCONFDIR,
  'LIBDIR': LIBDIR,

  'VERSION': meson.project_version(),
  'VARDIR': '/var/lib/firejail',
}

c_args_constants = []
foreach name, value : constants
  c_args_constants += '-D@0@="@1@"'.format(name, value)
endforeach

# # # # # # # #

firejail_sources = [
  'src/firejail/main.c',
  'src/firejail/appimage.c',
  'src/firejail/appimage_size.c',
  'src/firejail/arp.c',
  'src/firejail/bandwidth.c',
  'src/firejail/caps.c',
  'src/firejail/cgroup.c',
  'src/firejail/checkcfg.c',
  'src/firejail/cmdline.c',
  'src/firejail/cpu.c',
  'src/firejail/dhcp.c',
  'src/firejail/env.c',
  'src/firejail/fs.c',
  'src/firejail/fs_bin.c',
  'src/firejail/fs_dev.c',
  'src/firejail/fs_etc.c',
  'src/firejail/fs_home.c',
  'src/firejail/fs_hostname.c',
  'src/firejail/fs_lib.c',
  'src/firejail/fs_lib2.c',
  'src/firejail/fs_logger.c',
  'src/firejail/fs_mkdir.c',
  'src/firejail/fs_trace.c',
  'src/firejail/fs_var.c',
  'src/firejail/fs_whitelist.c',
  'src/firejail/ids.c',
  'src/firejail/join.c',
  'src/firejail/ls.c',
  'src/firejail/macros.c',
  'src/firejail/mountinfo.c',
  'src/firejail/netfilter.c',
  'src/firejail/netns.c',
  'src/firejail/network.c',
  'src/firejail/network_main.c',
  'src/firejail/no_sandbox.c',
  'src/firejail/paths.c',
  'src/firejail/preproc.c',
  'src/firejail/profile.c',
  'src/firejail/protocol.c',
  'src/firejail/pulseaudio.c',
  'src/firejail/restricted_shell.c',
  'src/firejail/restrict_users.c',
  'src/firejail/rlimit.c',
  'src/firejail/run_files.c',
  'src/firejail/run_symlink.c',
  'src/firejail/sandbox.c',
  'src/firejail/sbox.c',
  'src/firejail/seccomp.c',
  'src/firejail/selinux.c',
  'src/firejail/shutdown.c',
  'src/firejail/usage.c',
  'src/firejail/util.c',
  'src/firejail/x11.c',

  'src/lib/common.c',
  'src/lib/errno.c',
  'src/lib/firejail_user.c',
  'src/lib/ldd_utils.c',
  'src/lib/syscall.c',
]

executable('firejail', firejail_sources,
  install: true,
  install_mode: ['rwsr-xr-x', 0, 0],

  c_args: [
    c_args_constants
  ],
)

# # # # # # # #

fseccomp_sources = [
  'src/fseccomp/main.c',
  'src/fseccomp/protocol.c',
  'src/fseccomp/seccomp.c',
  'src/fseccomp/seccomp_file.c',
  'src/fseccomp/seccomp_secondary.c',

  'src/lib/common.c',
  'src/lib/errno.c',
  'src/lib/syscall.c',
]
fseccomp = executable('fseccomp', fseccomp_sources,
  install: true,
  install_dir: get_option('libdir') / meson.project_name(),
)

# TODO: fsec-optimize OUTPUT
custom_target('seccomp',
  build_by_default: true,
  command: [fseccomp, 'default', '@OUTPUT@'],
  install: true,
  install_dir: get_option('libdir') / meson.project_name(),
  output: 'seccomp',
)

# TODO: fsec-optimize OUTPUT
custom_target('seccomp.32',
  build_by_default: true,
  command: [fseccomp, 'secondary', '32', '@OUTPUT@'],
  install: true,
  install_dir: get_option('libdir') / meson.project_name(),
  output: 'seccomp.32',
)
