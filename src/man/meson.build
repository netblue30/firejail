gawk = find_program('gawk', required: false)
gzip = find_program('gzip', required: false)

# TODO: preproc.awk is also used by completions
if not gawk.found() or not gzip.found()
  message('Disable manpage because of missing requirements.')
  subdir_done()
endif

# The kwarg env: of run_command is only supported by meson>=0.50
month = run_command(sh, '-c', 'LC_ALL=C date -u +%b', check: true).stdout()
year = run_command(sh, '-c', 'LC_ALL=C date -u +%Y', check: true).stdout()

manconf = configuration_data()
manconf.set('VERSION', meson.project_version())
manconf.set('MONTH', month)
manconf.set('YEAR', year)

preproc_awk = files('preproc.awk')
preproc = generator(gawk,
  arguments: ['-f', './preproc.awk', '--', facilities, '@INPUT@'],
  capture: true,
  output: '@PLAINNAME@',
)

# Should we compress manpages?
# https://mesonbuild.com/Release-notes-for-0-49-0.html#manpages-are-no-longer-compressed-implicitly
compress = generator(gzip,
  arguments: ['-9n', '@INPUT@'],
  output: '@BASENAME@.gz'
)

manpages = {
  'firecfg.txt': '1',
  'firejail-login.txt': '5',
  'firejail-profile.txt': '5',
  'firejail.txt': '1',
  'firejail-users.txt': '5',
  'firemon.txt': '1',
  'jailcheck.txt': '1',
}

# TODO: Refactor, use custom_target and maybe a own build-aux/make-manpages script
# FIXME: Does only work with meson >=0.57
foreach manpage, section : manpages
  manpage = configure_file(
    configuration: manconf,
    input: manpage,
    output: '@BASENAME@.@0@'.format(section),
  )
  manpage = preproc.process(manpage)
  manpage = compress.process(manpage)
  #FIXME: does not work
  install_man(manpage[0], install_dir: get_option('mandir') / 'man' + section)
endforeach
