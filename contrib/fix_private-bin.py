#!/usr/bin/python3

__author__ = "KOLANICH"
__copyright__ = """This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <https://unlicense.org/>"""
__license__ = "Unlicense"

import sys, os, glob, re

privRx = re.compile("^(?:#\s*)?private-bin")


def fixSymlinkedBins(files, replMap):
    """
	Used to add filenames to private-bin directives of files if the ones present are mentioned in replMap
	replMap is a dict where key is the marker filename and value is the filename to add
	"""

    rxs = dict()
    for (old, new) in replMap.items():
        rxs[old] = re.compile("\\b" + old + "\\b")
        rxs[new] = re.compile("\\b" + new + "\\b")
    #print(rxs)

    for filename in files:
        lines = None
        with open(filename, "r") as file:
            lines = file.readlines()

        shouldUpdate = False
        for (i, line) in enumerate(lines):
            if privRx.search(line):
                for (old, new) in replMap.items():
                    if rxs[old].search(line) and not rxs[new].search(line):
                        lines[i] = rxs[old].sub(old + "," + new, line)
                        shouldUpdate = True
                        print(lines[i])

        if shouldUpdate:
            with open(filename, "w") as file:
                file.writelines(lines)


def createSetOfBinaries(files):
    """
	Creates a set of binaries mentioned in private-bin directives of files.
	"""
    s = set()
    for filename in files:
        with open(filename, "r") as file:
            for line in file:
                if privRx.search(line):
                    bins = line.split(",")
                    bins[0] = bins[0].split(" ")[-1]
                    bins = [n.strip() for n in bins]
                    s = s | set(bins)
    return s


def createSymlinkTable(binDirs, binariesSet):
    """
	creates a dict of symlinked binaries in the system where a key is a symlink name and value is a symlinked binary.
	binDirs are folders to look into for binaries symlinks
	binariesSet is a set of binaries to be checked if they are actually a symlinks
	"""
    m = dict()
    toProcess = binariesSet
    while len(toProcess) != 0:
        additional = set()
        for sh in toProcess:
            for bD in binDirs:
                p = bD + os.path.sep + sh
                if os.path.exists(p):
                    if os.path.islink(p):
                        m[sh] = os.readlink(p)
                        additional.add(m[sh].split(" ")[0])
                    else:
                        pass
                    break
        toProcess = additional
    return m


def doTheFixes(profilesPath, binDirs):
    """
	Fixes private-bin in .profiles for firejail. The pipeline is as follows:
	discover files -> discover mentioned binaries ->
	discover the ones which are symlinks ->
	make a look-up table for fix ->
	filter the ones can be fixed (we cannot fix the ones which are not in directories for binaries) ->
	apply fix
	"""
    files = glob.glob(profilesPath + os.path.sep + "*.profile")
    bins = createSetOfBinaries(files)
    #print("The binaries used are:")
    #print(bins)
    stbl = createSymlinkTable(binDirs, bins)
    print("The replacement table is:")
    print(stbl)
    stbl = {
        a[0]: a[1]
        for a in stbl.items()
        if a[0].find(os.path.sep) < 0 and a[1].find(os.path.sep) < 0
    }
    print("Filtered replacement table is:")
    print(stbl)
    fixSymlinkedBins(files, stbl)


def printHelp():
    print("python3 " + os.path.basename(__file__) +
          " <dir with .profile files>\nThe default dir is " +
          defaultProfilesPath + "\n" + doTheFixes.__doc__)


def main():
    """The main function. Parses the commandline args, shows messages and calles the function actually doing the work."""
    print(repr(sys.argv))
    defaultProfilesPath = "../etc"
    if len(sys.argv) > 2 or (len(sys.argv) == 2 and
                             (sys.argv[1] == '-h' or sys.argv[1] == '--help')):
        printHelp()
        exit(1)

    profilesPath = None
    if len(sys.argv) == 2:
        if os.path.isdir(sys.argv[1]):
            profilesPath = os.path.abspath(sys.argv[1])
        else:
            if os.path.exists(sys.argv[1]):
                print(sys.argv[1] + " is not a dir")
            else:
                print(sys.argv[1] + " does not exist")
            printHelp()
            exit(1)
    else:
        print("Using default profiles dir: " + defaultProfilesPath)
        profilesPath = defaultProfilesPath

    binDirs = [
        "/bin", "/usr/bin", "/usr/sbin", "/usr/local/bin", "/usr/local/sbin"
    ]
    print("Binaries dirs are:")
    print(binDirs)
    doTheFixes(profilesPath, binDirs)


if __name__ == "__main__":
    main()
