project('firejail', 'c',
  license: 'GPL-2.0-or-later',
  default_options: [
    # -D_FORTIFY_SOURCE=2 requires optimization
    'buildtype=debugoptimized',
    'strip=true',
    'b_pie=true',
  ],
  # https://packages.debian.org/oldstable/meson
  meson_version: '>=0.56.2',
  version: '0.9.73',
)

# # # # # # # # # #

c_compiler = meson.get_compiler('c')
cc = find_program(c_compiler.cmd_array()[0])
sh = find_program('sh')
gawk = find_program('gawk')

project_name = meson.project_name()
prefix = get_option('prefix')
bindir = get_option('bindir')
datadir = get_option('datadir')
bashcompletiondir = datadir / 'bash-completion' / 'completions'
docdir = datadir / 'doc' / project_name
zshcompletiondir = datadir / 'zsh' / 'site-functions'
sysconfdir = get_option('sysconfdir')
libdir = get_option('libdir')
libdir_firejail = libdir / project_name
firejail_perms = get_option('suid') ? 'rwsr-xr-x' : 'rwxr-xr-x'
sbox_apps_non_dumpable_perms = 'rwx--x--x'

noopdep = dependency('', required: false)
libapparmor = get_option('apparmor') ? dependency('libapparmor') : noopdep
libselinux = get_option('selinux') ? dependency('libselinux') : noopdep

# # # # # # # # # #

if get_option('lts')
  # meson _builddir_lts --prefix=/usr -Dlts=true -Dchroot=false -Ddbusproxy=false -Dfile-transfer=false -Dfiretunnel=false -Dglobalcfg=false -Doutput=false -Dprivate-home=false -Duserns=false -Dusertmpfs=false -Dx11=false
  foreach option : ['chroot', 'dbusproxy', 'file-transfer', 'firetunnel', 'globalcfg',
                    'output', 'private-home', 'userns', 'usertmpfs', 'x11']
    assert(get_option(option) == false, 'get_option(\'@0@\') == false'.format(option))
  endforeach
endif


# Enable static analysis if wanted and supported.
if get_option('analyzer') and c_compiler.has_argument('-fanalyzer')
  add_project_arguments('-fanalyzer', language: 'c')
  add_project_arguments('-Wno-analyzer-malloc-leak', language: 'c')
endif

c_args = []
if get_option('buildtype') != 'plain'
  c_args += c_compiler.get_supported_arguments([
    '-mretpoline',
    '-fstack-protector-strong',
    '-fstack-clash-protection',
    '-D_FORTIFY_SOURCE=2',
  ])
  if get_option('warning_level').to_int() > 0
    c_args += ['-Wformat', '-Wformat-security']
  endif
endif


facilities = []
foreach option, flag : {
    'apparmor': '-DHAVE_APPARMOR',
    'chroot': '-DHAVE_CHROOT',
    'dbusproxy': '-DHAVE_DBUSPROXY',
    'file-transfer': '-DHAVE_FILE_TRANSFER',
    'firetunnel': '-DHAVE_FIRETUNNEL',
    'force-nonewprivs': '-DHAVE_FORCE_NONEWPRIVS',
    'globalcfg': '-DHAVE_GLOBALCFG',
    'ids': '-DHAVE_IDS',
    'lts': '-DHAVE_LTS',
    'network': '-DHAVE_NETWORK',
    'output': '-DHAVE_OUTPUT',
#    'overlayfs': '-DHAVE_OVERLAYFS',
    'private-home': '-DHAVE_PRIVATE_HOME',
    'selinux': '-DHAVE_SELINUX',
    'suid': '-DHAVE_SUID',
    'userns': '-DHAVE_USERNS',
    'usertmpfs': '-DHAVE_USERTMPFS',
#    'whitelist': '-DHAVE_WHITELIST',
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

install_data('COPYING', 'README', 'RELNOTES',
  install_dir: docdir,
)

# # # # # # # # # #

cppcheck = find_program('cppcheck', required: false)
if cppcheck.found()
  run_target('cppcheck',
    command: [
      cppcheck, '--force', '--error-exitcode=1', '--enable=warning,performance', meson.source_root(),
    ],
  )
endif

# # # # # # # # # #

show_summary = true
if show_summary and meson.version().version_compare('>=0.53.0')
  summary('prefix', prefix, section: 'Directories')
  summary('bindir', bindir, section: 'Directories')
  summary('datadir', datadir, section: 'Directories')
  summary('docdir', docdir, section: 'Directories')
  summary('sysconfdir', sysconfdir, section: 'Directories')
  summary('libdir', libdir, section: 'Directories')
  summary('libdir_firejail', libdir_firejail, section: 'Directories')

  summary('apparmor', get_option('apparmor'), section: 'Facilities')
  summary('chroot', get_option('chroot'), section: 'Facilities')
  summary('dbusproxy', get_option('dbusproxy'), section: 'Facilities')
  summary('file-transfer', get_option('file-transfer'), section: 'Facilities')
  summary('firetunnel', get_option('firetunnel'), section: 'Facilities')
  summary('force-nonewprivs', get_option('force-nonewprivs'), section: 'Facilities')
  summary('globalcfg', get_option('globalcfg'), section: 'Facilities')
  summary('ids', get_option('ids'), section: 'Facilities')
  summary('network', get_option('network'), section: 'Facilities')
  summary('output', get_option('output'), section: 'Facilities')
  summary('overlayfs', get_option('overlayfs'), section: 'Facilities')
  summary('private-home', get_option('private-home'), section: 'Facilities')
  summary('selinux', get_option('selinux'), section: 'Facilities')
  summary('suid', get_option('suid'), section: 'Facilities')
  summary('userns', get_option('userns'), section: 'Facilities')
  summary('usertmpfs', get_option('usertmpfs'), section: 'Facilities')
  summary('whitelist', get_option('whitelist'), section: 'Facilities')
  summary('x11', get_option('x11'), section: 'Facilities')

  summary('lts', get_option('lts'), section: 'LTS')

  summary('busybox-workaround', get_option('busybox-workaround'), section: 'Misc')
  summary('contrib', get_option('contrib'), section: 'Misc')
  summary('manpage', get_option('manpage'), section: 'Misc')
endif

conf = configuration_data()
conf.set('PACKAGE_BUGREPORT', 'netblue30@protonmail.com')
conf.set('PACKAGE_NAME', 'firejail')
conf.set('PACKAGE_STRING', 'firejail ' + meson.project_version())
conf.set('PACKAGE_TARNAME', 'firejail')
conf.set('PACKAGE_VERSION', meson.project_version())
conf.set_quoted('PACKAGE_URL', 'https://firejail.wordpress.com')

test_config_sh = configure_file(
  configuration: conf,
  input: 'config.sh.in',
  output: '@BASENAME@',
)
