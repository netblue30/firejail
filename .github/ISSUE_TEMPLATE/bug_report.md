---
name: Bug report
about: Create a report to help us improve
title: ''
labels: ''
assignees: ''

---

Write clear, concise and in textual form.

### Bug and expected behavior

- Describe the bug.
- What did you expect to happen?

### No profile and disabling firejail

- What changed calling `firejail --noprofile /path/to/program` in a terminal?
- What changed calling the program by path (e.g. `/usr/bin/vlc`)?

### Reproduce

Steps to reproduce the behavior:

1. Run in bash `firejail PROGRAM`
2. See error `ERROR`
3. Click on '....'
4. Scroll down to '....'

### Environment

- Linux distribution and version (ie output of `lsb_release -a`, `screenfetch` or `cat /etc/os-release`)
- Firejail version (output of `firejail --version`) exclusive or used git commit (`git rev-parse HEAD`)

### Additional context

Other context about the problem like related errors to understand the problem.

### Checklist

- [ ] The profile (and redirect profile if exists) hasn't already been fixed [upstream](https://github.com/netblue30/firejail/tree/master/etc).
- [ ] The program has a profile. (If not, request one in `https://github.com/netblue30/firejail/issues/1139`)
- [ ] I have performed a short search for similar issues (to avoid opening a duplicate).
- [ ] If it is a AppImage, `--profile=PROFILENAME` is used to set the right profile.
- [ ] Used `LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 PROGRAM` to get english error-messages.
- [ ] I'm aware of `browser-allow-drm yes`/`browser-disable-u2f no` in `firejail.config` to allow DRM/U2F in browsers.
- [ ] This is not a question. Questions should be asked in https://github.com/netblue30/firejail/discussions.

### Log

<details>
<summary>debug output</summary>
<p>

```
OUTPUT OF `firejail --debug PROGRAM`
```

</p>
</details>
