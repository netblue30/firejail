---
name: Bug report
about: Create a report to help us improve
title: ''
labels: ''
assignees: ''

---
Write clear, concise and in textual form.

**Bug and expected behavior**
- Describe the bug.
- What did you expect to happen?

**No profile and disabling firejail**
- What changed calling `firejail --noprofile /path/to/program` in a terminal?
- What changed calling the program by path (check `which <program>` or `firejail --list` while the sandbox is running)?

**Reproduce**
Steps to reproduce the behavior:
1. Run in bash `firejail PROGRAM`
2. See error `ERROR`
3. Click on '....'
4. Scroll down to '....'

**Environment**
 - Linux distribution and version (ie output of `lsb_release -a`, `screenfetch` or `cat /etc/os-release`)
 - Firejail version (output of `firejail --version`) exclusive or used git commit (`git rev-parse HEAD`) 

**Additional context**
Other context about the problem like related errors to understand the problem.

**Checklist**
 - [ ] The upstream profile (and redirect profile if exists) have no changes fixing it.
 - [ ] The program has a profile. (If not, request one in `https://github.com/netblue30/firejail/issues/1139`)
 - [ ] Programs needed for interaction are listed in the profile.
 - [ ] A short search for duplicates was performed.
 - [ ] If it is a AppImage, `--profile=PROFILENAME` is used to set the right profile.


<details><summary> debug output </summary>

```
OUTPUT OF `firejail --debug PROGRAM`
```

</details>
