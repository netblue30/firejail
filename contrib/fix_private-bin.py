#!/usr/bin/env python3
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

import typing
import sys, os, re
from collections import OrderedDict
from pathlib import Path
from shutil import which

privRx = re.compile(r"^(#\s*)?(private-bin)(\s+)(.+)$")


def fixSymlinkedBins(files: typing.List[Path], replMap: typing.Dict[str, str]) -> None:
    """
    Used to add filenames to private-bin directives of files if the ones present are mentioned in replMap
    replMap is a dict where key is the marker filename and value is the filename to add
    """

    for filename in files:
        lines = filename.read_text(encoding="utf-8").split("\n")

        shouldUpdate = False
        for (i, line) in enumerate(lines):
            m = privRx.match(line)
            if m:
                lineUpdated = False
                mBins = OrderedDict((sb, sb) for sb in (b.strip() for b in m.group(4).split(",")))

                for (old, new) in replMap.items():
                    if old in mBins:
                        #print(old, "->", new)
                        if new not in mBins:
                            mBins[old] = old + "," + new
                            lineUpdated = True

                if lineUpdated:
                    comment = m.group(1)
                    if comment is None:
                        comment = ""
                    lines[i] = comment + m.group(2) + m.group(3) + ",".join(mBins.values())
                    shouldUpdate = True

        if shouldUpdate:
            filename.write_text("\n".join(lines), encoding="utf-8")


def createSetOfBinaries(files: typing.List[Path]) -> typing.Set[str]:
    """
    Creates a set of binaries mentioned in private-bin directives of files.
    """
    s = set()
    for filename in files:
        with open(filename, "r") as file:
            for line in file:
                m = privRx.match(line)
                if m:
                    bins = m.group(4).split(",")
                    bins = [n.strip() for n in bins]
                    s = s | set(bins)
    return s

def getExecutableNameFromLink(p: Path) -> str:
    return os.readlink(str(p)).split(" ")[0]


forbiddenExecutables= ["firejail"]

def populateForbiddenExecutables():
    forbiddenSymlinks = []
    for e in forbiddenExecutables:
        r = which(e)
        if r is not None:
            yield r

forbiddenSymlinks = set(populateForbiddenExecutables())


def createSymlinkTable(binDirs: typing.Iterable[Path], binariesSet: typing.Set[str]) -> typing.Mapping[str, str]:
    """
    creates a dict of symlinked binaries in the system where a key is a symlink name and value is a symlinked binary.
    binDirs are folders to look into for binaries symlinks
    binariesSet is a set of binaries to be checked if they are actually a symlinks
    """
    m = dict()
    toProcess = binariesSet
    while len(toProcess) != 0:
        additional = set()
        for binName in toProcess:
            for binaryDir in binDirs:
                p = binaryDir / binName
                if p.is_symlink():
                    res = []
                    nm = getExecutableNameFromLink(p)
                    if nm in forbiddenSymlinks:
                        continue
                    m[binName] = nm
                    additional.add(nm)
                    break

        toProcess = additional
    return m


def doTheFixes(profilesPath: Path, binDirs: typing.Iterable[Path]) -> None:
    """
    Fixes private-bin in .profiles for firejail. The pipeline is as follows:
    discover files -> discover mentioned binaries ->
    discover the ones which are symlinks ->
    make a look-up table for fix ->
    filter the ones can be fixed (we cannot fix the ones which are not in directories for binaries) ->
    apply fix
    """
    files = list(profilesPath.glob("**/*.profile"))
    bins = createSetOfBinaries(files)
    #print("The binaries used are:")
    #print(bins)
    stbl = createSymlinkTable(binDirs, bins)
    print("The replacement table is:")
    print(stbl)
    for k, v in tuple(stbl.items()):
        if k.find(os.path.sep) < 0 and v.find(os.path.sep) < 0:
            pass
        else:
            del stbl[k]

    print("Filtered replacement table is:")
    print(stbl)
    fixSymlinkedBins(files, stbl)


thisDir = Path(__file__).absolute().parent
defaultProfilesPath = (thisDir.parent / "etc")


def printHelp():
    print("python3 " + str(thisDir) +
          " <dir with .profile files>\nThe default dir is " +
          str(defaultProfilesPath) + "\n" + doTheFixes.__doc__)


def main() -> None:
    """The main function. Parses the commandline args, shows messages and calls the function actually doing the work."""
    if len(sys.argv) > 2 or (len(sys.argv) == 2 and
                             (sys.argv[1] == "-h" or sys.argv[1] == "--help")):
        printHelp()
        sys.exit(1)

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
            sys.exit(1)
    else:
        print("Using default profiles dir: ", defaultProfilesPath)
        profilesPath = defaultProfilesPath

    binDirs = ("/bin", "/usr/bin", "/usr/bin", "/usr/sbin", "/usr/local/bin", "/usr/local/sbin")
    binDirs = type(binDirs)(Path(p) for p in binDirs)

    print("Binaries dirs are:")
    print(binDirs)
    doTheFixes(profilesPath, binDirs)


if __name__ == "__main__":
    main()
