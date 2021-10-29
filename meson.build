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

subdir('src/firecfg')
subdir('src/firejail')
subdir('src/firemon')
subdir('src/jailcheck')

subdir('src/fbuilder')
subdir('src/fcopy')
subdir('src/fids')
subdir('src/fldd')
subdir('src/fnet')
subdir('src/fnetfilter')
subdir('src/fseccomp')
subdir('src/ftee')

# # # # # # # #

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
