project('firejail', 'c',
  license: 'GPL-2.0-or-later',
  # https://packages.debian.org/oldstable/meson
  meson_version: '>=0.49.2',
  version: '0.9.67',
)

# # # # # # # # # #

# TODO:
# -mindirect-branch=thunk
# -mretpoline
# -fstack-clash-protection
# -fstack-protector-strong
# -fstack-protector-all -D_FORTIFY_SOURCE=2 -fPIE -Wformat -Wformat-security
# -pie -fPIE -Wl,-z,relro -Wl,-z,now -lpthread

cc = meson.get_compiler('c')
if get_option('analyzer') and cc.get_id() == 'gcc' and cc.version().version_compare('>=10')
  add_project_arguments('-fanalyzer', language: 'c')
  add_project_arguments('-Wno-analyzer-malloc-leak', language: 'c')
endif

if get_option('sanitizer') != 'none'
  # TODO: MSAN is not supported by gcc (i.e. requires clang)
  # TODO: -fno-common? https://github.com/google/sanitizers/wiki/AddressSanitizer#faq
  add_project_arguments('-fsanitize=' + get_option('sanitizer'), language: 'c')
  add_project_arguments('-fno-omit-frame-pointer', language: 'c')
  #add_project_link_arguments()
endif

option_flag = {
  'chroot': '-DHAVE_CHROOT',
  'dbusproxy': '-DHAVE_DBUSPROXY',
  'file-transfer': '-DHAVE_FILE_TRANSFER',
  'firetunnel': '-DHAVE_FIRETUNNEL',
  'force-nonewprivs': '-DHAVE_FORCE_NONEWPRIVS',
  #'globalcfg': '-DHAVE_GLOBALCFG'
  'network': '-DHAVE_NETWORK',
  'output': '-DHAVE_OUTPUT',
  'private-home': '-DHAVE_PRIVATE_HOME',
  #not suid -DHAVE_NOSUID
  'userns': '-DHAVE_USERNS',
  'usertmpfs': '-DHAVE_USERTMPFS',
  'x11': '-DHAVE_X11',
}

manflags = []
foreach option, flag : option_flag
  if get_option(option)
    manflags += flag
  else
  endif
  #set_variable(name, value)
endforeach

# # # # # # # # # #

if get_option('contrib')
  subdir('contrib')
endif
subdir('etc')
subdir('src')
subdir('test')

install_data(['COPYING', 'README', 'RELNOTES'],
  # docdir ?
  install_dir: get_option('datadir') / 'doc' / meson.project_name(),
)
