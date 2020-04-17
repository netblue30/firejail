---
name: Bug report
about: Create a report to help us improve
title: ''
labels: ''
assignees: ''

---
Write clear, concise and in textual form.

**Description, expectation and unrelated**
1. Describe the bug.
2. What did you expect to happen?
3. Check the bug in a search engine and summarize your results.

**Behavior change on disabling firejail**
4. What changed calling `firejail --noprofile PROGRAM` in a shell?
5. What changed calling the program *by path* (without firejail, check `whereis PROGRAM`, `firejail --list`, `stat $PATH`)?

**Environment**
6. Linux distribution and version (ie output of `lsb_release -a`)
7. Firejail version (output of `firejail --version`) exclusive or used git commit (`git rev-parse HEAD`)

**Steps to reproduce (if needed)**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

**Additional context**
Add any other context about the problem here.
