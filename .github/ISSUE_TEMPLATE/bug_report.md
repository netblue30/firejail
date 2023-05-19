---
name: Bug report
about: Create a report to help us improve
title: ''
labels: ''
assignees: ''

---

<!--
See the following links for help with formatting:

https://guides.github.com/features/mastering-markdown/
https://docs.github.com/en/github/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax
-->

### Description

_Describe the bug_

### Steps to Reproduce

_Steps to reproduce the behavior_

1. Run in bash `LC_ALL=C firejail PROGRAM` (`LC_ALL=C` to get a consistent
   output in English that can be understood by everybody)
2. Click on '....'
3. Scroll down to '....'
4. See error `ERROR`

### Expected behavior

_What you expected to happen_

### Actual behavior

_What actually happened_

### Behavior without a profile

_What changed calling `LC_ALL=C firejail --noprofile /path/to/program` in a
terminal?_

### Additional context

_Any other detail that may help to understand/debug the problem_

### Environment

- Linux distribution and version (e.g. "Ubuntu 20.04" or "Arch Linux")
- Firejail version (`firejail --version`).
- If you use a development version of firejail, also the commit from which it
  was compiled (`git rev-parse HEAD`).

### Checklist

<!--
Note: Items are checked with an "x", like so:

- [x] This is a checked item.
-->

- [ ] The issues is caused by firejail (i.e. running the program by path (e.g. `/usr/bin/vlc`) "fixes" it).
- [ ] I can reproduce the issue without custom modifications (e.g. globals.local).
- [ ] The program has a profile. (If not, request one in `https://github.com/netblue30/firejail/issues/1139`)
- [ ] The profile (and redirect profile if exists) hasn't already been fixed [upstream](https://github.com/netblue30/firejail/tree/master/etc).
- [ ] I have performed a short search for similar issues (to avoid opening a duplicate).
  - [ ] I'm aware of `browser-allow-drm yes`/`browser-disable-u2f no` in `firejail.config` to allow DRM/U2F in browsers.
- [ ] I used `--profile=PROFILENAME` to set the right profile. (Only relevant for AppImages)

### Log

<details>
<summary>Output of <code>LC_ALL=C firejail /path/to/program</code></summary>
<p>

```
output goes here
```

</p>
</details>

<details>
<summary>Output of <code>LC_ALL=C firejail --debug /path/to/program</code></summary>
<p>

<!-- If the output is too long to embed it into the comment,
     create a secret gist at https://gist.github.com/ and link it here. -->

```
output goes here
```

</p>
</details>
