project('firejail', 'c',
  license: 'GPL-2.0-or-later',
  # https://packages.debian.org/oldstable/meson
  meson_version: '>=0.49.2',
  version: '0.9.67',
)

cc = meson.get_compiler('c')
if get_option('analyzer') and cc.get_id() == 'gcc' and cc.version().version_compare('>=10')
  add_project_arguments('-fanalyzer', language: 'c')
endif

subdir('etc')
subdir('src')
subdir('test')
