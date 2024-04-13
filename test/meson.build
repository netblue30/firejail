test_dirs = [
  'apparmor',
  'appimage',
  'apps',
  'apps-x11',
  'apps-x11-xorg',
  'capabilities',
  'chroot',
  'compile',
  'environment',
  'fcopy',
  'filters',
  'firecfg',
  'fnetfilter',
  'fs',
  'network',
  'private-etc',
  'private-lib',
  'profiles',
  'seccomp-extra',
  'sysutils',
  'utils',
]
build_test_sh = files('build-test.sh')
foreach test_dir : test_dirs
	test(test_dir, build_test_sh, args: [meson.current_source_dir(), test_dir, meson.project_build_root()], timeout: 600)
endforeach
