#!/usr/bin/env python3
# This file is part of Firejail project
# Copyright (C) 2014-2020 Firejail Authors
# License GPL v2
"""
Figure out which profile options may be causing a particular program to break
when run in firejail.

Instead of having to comment out each line in a profile by hand, and then
enable each line individually until the bad line or lines are found, this
largely automates the process. Users only have to provide the path to the
profile, program name, and answer 'y' for yes or 'n' for no when prompted.

After completion, you'll be provided with some information to copy and then
paste into a GitHub issue in the Firejail project repository:
https://github.com/netblue30/firejail/issues

Paths to the profile should be absolute. If the program is in your path, then
you only have to type the profile name. Else, you'll need to provide the
absolute path to the profile.

Examples:
python jail_prober.py /etc/firejail/spotify.profile spotify
python jail_prober.py /usr/local/etc/firejail/firefox.profile /usr/bin/firefox
"""

import sys
import os
import subprocess


def check_params(profilePath):
    """
    Ensure the path to the profile is valid and that an actual profile has been
    passed (as opposed to a config or .local file).

    :params profilePath: The absolute path to the problematic profile.
    """
    if not os.path.isfile(profilePath):
        raise FileNotFoundError(
            'The path %s is not a valid system path.' % profilePath)
    if not profilePath.endswith('.profile'):
        raise ValueError('%s is not a valid Firejail profile.' % profilePath)


def get_args(profilePath):
    """
    Read the profile, stripping out comments and newlines

    :params profilePath: The absolute path to the problematic profile.

    :returns profile: A list containing all active profile arguments
    """
    with open(profilePath, 'r') as f:
        profile = f.readlines()
        profile = [
            arg.strip() for arg in profile
            if not arg.startswith('#') and arg.strip() != ''
        ]

    return profile


def arg_converter(argList, style):
    """
    Convert between firejail command-line arguments (--example=something) and
    profile arguments (example something)

    :params argList: A list of firejail arguments

    :params style: Whether to convert arguments to command-line form or profile
    form
    """
    if style == 'to_profile':
        oldSep = '='
        newSep = ' '
        prefix = ''
    elif style == 'to_commandline':
        oldSep = ' '
        newSep = '='
        prefix = '--'
    newArgs = [prefix + word.replace(oldSep, newSep) for word in argList]
    # Additional strip of '--' if converting to profile form
    if style == 'to_profile':
        newArgs = [word[2:] for word in newArgs]

    # Remove invalid '--include' args if converting to command-line form
    elif style == 'to_commandline':
        newArgs = [word for word in newArgs if 'include' not in word]

    return newArgs


def run_firejail(program, allArgs):
    """
    Attempt to run the program in firejail, incrementally adding to the number
    of firejail arguments. Initial run has no additional params besides
    noprofile.

    :params program: The program name. If it doesn't exist in the user's path
    then the full path should be provided.

    :params allArgs: A list of all Firejail arguments to try, in command-line
    format.

    :returns goodArgs: A list of arguments that the user has reported to not
    affect the program

    :returns badArgs: A list of arguments that the user has reported to break
    the program when sandboxing with Firejail
    """
    goodArgs = ['firejail', '--noprofile', program]
    badArgs = []
    print('Attempting to run %s in Firejail' % program)
    for arg in allArgs:
        print('Running with', arg)
        #We are adding the argument in a copy of the actual list to avoid modify it now.
        myargs=goodArgs.copy()
        myargs.insert(-1,arg)
        subprocess.call(myargs)
        ans = input('Did %s run correctly? [y]/n ' % program)
        if ans in ['n', 'N']:
            badArgs.append(arg)
        else:
            goodArgs.insert(-1, arg)
        print('\n')
    # Don't include 'firejail', '--noprofile', or program name in arguments
    goodArgs = goodArgs[2:-1]

    return goodArgs, badArgs


def main():
    profilePath = sys.argv[1]
    program = sys.argv[2]
    # Quick error check and extract arguments
    check_params(profilePath)
    profile = get_args(profilePath)
    allArgs = arg_converter(profile, 'to_commandline')
    # Find out which profile options break the program when running in firejail
    goodArgs, badArgs = run_firejail(program, allArgs)

    goodArgs = arg_converter(goodArgs, 'to_profile')
    badArgs = arg_converter(badArgs, 'to_profile')

    print('\n###########################')
    print('Debugging completed.')
    print(
        'Please copy the following and report it to the Firejail development',
        'team on GitHub at %s \n\n' %
        'https://github.com/netblue30/firejail/issues')

    subprocess.call(['firejail', '--version'])

    print('These profile options break the program.')
    print('```')
    for item in badArgs:
        print(item)
    print('```\n\n\n')

    print('This is a minimal working profile:')
    print('```')
    for item in goodArgs:
        print(item)
    print('```')


if __name__ == '__main__':
    main()
