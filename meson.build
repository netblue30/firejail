project('firejail', 'c',
  license: 'GPL-2.0-or-later',
  default_options: [
    'b_pie=true',
  ],
  # https://packages.debian.org/oldstable/meson
  meson_version: '>=0.49.2',
  version: '0.9.67',
)

# # # # # # # # # #

c_compiler = meson.get_compiler('c')
cc = find_program(c_compiler.cmd_array()[0])
sh = find_program('sh')

project_name = meson.project_name()
prefix = get_option('prefix')
bindir = get_option('bindir')
datadir = get_option('datadir')
docdir = datadir / 'doc' / project_name
sysconfdir = get_option('sysconfdir')
libdir = get_option('libdir')
libdir_firejail = libdir / project_name
firejail_perms = get_option('suid') ? 'rwsr-xr-x' : 'rwxr-xr-x'
sbox_apps_non_dumpable_perms = 'rwx--x--x'

# # # # # # # # # #

# TODO:
# -Wl,-z,relro -Wl,-z,now -lpthread


# Enable static analysis if wanted and supported.
if get_option('analyzer') and c_compiler.has_argument('-fanalyzer')
  add_project_arguments('-fanalyzer', language: 'c')
  add_project_arguments('-Wno-analyzer-malloc-leak', language: 'c')
endif

# Default compiler flags
c_args = c_compiler.get_supported_arguments([
  '-mindirect-branch=thunk',
  '-mretpoline',
  '-fstack-protector-strong',
  '-fstack-clash-protection',
  '-D_FORTIFY_SOURCE=2',
])
if get_option('warning_level').to_int() > 0
  c_args += ['-Wformat', '-Wformat-security']
endif


facilities = []
foreach option, flag : {
    'chroot': '-DHAVE_CHROOT',
    'dbusproxy': '-DHAVE_DBUSPROXY',
    'file-transfer': '-DHAVE_FILE_TRANSFER',
    'firetunnel': '-DHAVE_FIRETUNNEL',
    'force-nonewprivs': '-DHAVE_FORCE_NONEWPRIVS',
    'globalcfg': '-DHAVE_GLOBALCFG',
    'network': '-DHAVE_NETWORK',
    'output': '-DHAVE_OUTPUT',
    'private-home': '-DHAVE_PRIVATE_HOME',
    'suid': '-DHAVE_SUID',
    'userns': '-DHAVE_USERNS',
    'usertmpfs': '-DHAVE_USERTMPFS',
    'x11': '-DHAVE_X11',
  }

  if get_option(option)
    facilities += flag
  endif
endforeach


constants = []
foreach name, value : {
  'PREFIX': prefix,
  'BINDIR': prefix / bindir,
  'SYSCONFDIR': prefix / sysconfdir / project_name,
  'LIBDIR': prefix / libdir,
  'VARDIR': '/var/lib' / project_name,
  'VERSION': meson.project_version(),
  }

  constants += '-D@0@="@1@"'.format(name, value)
endforeach

# # # # # # # # # #

if get_option('contrib')
  subdir('contrib')
endif
subdir('etc')
subdir('src')
subdir('test')

install_data(['COPYING', 'README', 'RELNOTES'],
  install_dir: docdir,
)

# # # # # # # # # #

# TODO: summary()
