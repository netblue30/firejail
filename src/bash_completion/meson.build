firejail_bash_completion = configure_file(
  configuration: {'SYSCONFDIR': sysconfdir},
  input: 'firejail.bash_completion.in',
  output: '@BASENAME@',
)
custom_target('firejail.bash_completion',
  build_by_default: true,
  capture: true,
  command: preproc_awk_cmd,
  input: firejail_bash_completion,
  install: true,
  install_dir: bashcompletiondir,
  output: 'firejail',
)

install_data('firecfg.bash_completion', 'firemon.bash_completion',
  install_dir: bashcompletiondir,
  rename: ['firecfg', 'firemon']
)
