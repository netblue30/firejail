# The kwarg env: of run_command is only supported by meson>=0.50
date = run_command(sh, '-c',
  'LC_ALL=C date --utc --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y-%b',
  check: true,
).stdout().strip().split('-')

manconf = configuration_data()
manconf.set('VERSION', meson.project_version())
manconf.set('YEAR', date[0])
manconf.set('MONTH', date[1])

manpages = [
  'firecfg.1',
  'firejail-login.5',
  'firejail-profile.5',
  'firejail.1',
  'firejail-users.5',
  'firemon.1',
  'jailcheck.1',
]

foreach manpage : manpages
  section = manpage.split('.')[1]
  configured_manpage = configure_file(
    configuration: manconf,
    input: manpage + '.in',
    output: '@PLAINNAME@',
  )
  custom_target(manpage,
    build_by_default: true,
    capture: true,
    command: preproc_awk_cmd,
    input: configured_manpage,
    install: true,
    install_dir: get_option('mandir') / 'man' + section,
    output: manpage,
  )
endforeach
