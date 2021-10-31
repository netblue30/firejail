preproc_awk = files('preproc.awk')

# The kwarg env: of run_command is only supported by meson>=0.50
month = run_command(sh, '-c', 'LC_ALL=C date -u +%b', check: true).stdout().strip()
year = run_command(sh, '-c', 'LC_ALL=C date -u +%Y', check: true).stdout().strip()

manconf = configuration_data()
manconf.set('VERSION', meson.project_version())
manconf.set('MONTH', month)
manconf.set('YEAR', year)

manpages = {
  'firecfg': '1',
  'firejail-login': '5',
  'firejail-profile': '5',
  'firejail': '1',
  'firejail-users': '5',
  'firemon': '1',
  'jailcheck': '1',
}

foreach manpage, section : manpages
  configured_manpage = configure_file(
    configuration: manconf,
    input: manpage + '.txt',
    output: '@PLAINNAME@',
  )
  custom_target(manpage + '.' + section,
    build_by_default: true,
    capture: true,
    command: [gawk, '-f', preproc_awk,  '--', facilities, '@INPUT@'],
    input: configured_manpage,
    install: true,
    install_dir: get_option('mandir') / 'man' + section,
    output: manpage + '.' + section,
  )
endforeach
