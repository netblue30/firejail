---
name: Bug report
about: Create a report to help us improve
title: ''
labels: ''
assignees: ''

---
Write clear, concise and in textual form.

**Behavior change on disabling firejail**
1. What changed calling `firejail --noprofile PROGRAM` in a shell?
2. What changed calling the program *by path*=without firejail (check `whereis PROGRAM`, `firejail --list`, `stat $programpath`)?

**Description, expectation and unrelated**
3. Describe the bug.
4. What did you expect to happen?
5. (helpful) Use `firejail --debug` what/if warning/error (usually in the last lines) occur.
6. (helpful) Check the warnings/error/bug in a search engine and summarize your results.

**Environment**
7. Linux distribution and version (ie output of `lsb_release -a`)
8. Firejail version (output of `firejail --version`) and, if used, git commit (`git rev-parse HEAD`)
9. (helpful) Are your installed programs which interact with the affected program listed in the profile? 
Check `find / -name 'firejail' 2>/dev/null'/'fd firejail' to locate profiles ie in `/usr/local/etc/firejail/PROGRAM.profile`
and search for them **or** describe them.

**Steps to reproduce (if needed)**
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

**Additional context**
Add any other context about the problem here.
