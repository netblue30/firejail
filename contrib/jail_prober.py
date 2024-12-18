#!/usr/bin/env python3
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
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


def check_params(profile_path):
    """
    Ensure the path to the profile is valid and that an actual profile has been
    passed (as opposed to a config or .local file).

    Args:
        profile_path:       The absolute path to the problematic profile

    Raises:
        FileNotFoundError:  If the provided path isn't real

        ValueError:         If the provided path is real but doesn't point to
                            a Firejail profile
    """
    if not os.path.isfile(profile_path):
        raise FileNotFoundError('The path %s is not a valid system path.' %
                                profile_path)
    if not profile_path.endswith('.profile'):
        raise ValueError('%s is not a valid Firejail profile.' % profile_path)


def get_args(profile_path):
    """
    Read the profile, stripping out comments and newlines

    Args:
        profile_path:   The absolute path to the problematic profile.

    Returns:
        A list containing all active profile arguments
    """
    with open(profile_path, 'r') as f:
        profile = f.readlines()
        profile = [
            arg.strip() for arg in profile
            if not arg.startswith('#') and arg.strip() != ''
        ]

    return profile


def absolute_include(word):
    home = os.environ['HOME']
    path = home + '/.config/firejail/'

    option, filename = word.split('=')
    absolute_filename = path + filename

    if not os.path.isfile(absolute_filename):
        absolute_filename = '${CFG}/' + filename

    return option + '=' + absolute_filename


def arg_converter(arg_list, style):
    """
    Convert between firejail command-line arguments (--example=something) and
    profile arguments (example something)

    Args:
        arg_list:   A list of firejail arguments

        style:      String, one of {'to_profile', 'to_commandline'}. Whether to
                    convert arguments to command-line form or profile form
    """
    if style == 'to_profile':
        old_sep = '='
        new_sep = ' '
        prefix = ''
    elif style == 'to_commandline':
        old_sep = ' '
        new_sep = '='
        prefix = '--'
    new_args = [prefix + word.replace(old_sep, new_sep) for word in arg_list]
    # Additional strip of '--' if converting to profile form
    if style == 'to_profile':
        new_args = [word[2:] for word in new_args]

    elif style == 'to_commandline':
        new_args = [
            absolute_include(word) if word.startswith('--include')
            else word
            for word in new_args
        ]

    return new_args


def run_firejail(program, all_args):
    """
    Attempt to run the program in firejail, incrementally adding to the number
    of firejail arguments. Initial run has no additional params besides
    noprofile.

    Args:
        program:    String, the program name. If it doesn't exist in $PATH then
                    the full path to the program should be provided

        all_args:   List, all Firejail arguments to try, in command-line format
                    (i.e. prefixed by '--')

    Returns:
        good_args:  List, all Firejail arguments that the user has reported to
                    not adversely affect the program

        bad_args:   List, all Firejail arguments that the user has reported to
                    break the program
    """
    good_args = ['firejail', '--noprofile', program]
    bad_args = []
    all_args.insert(0, "")
    print('Attempting to run %s in Firejail' % program)
    for arg in all_args:
        if arg:
            print('Running with', arg)
        else:
            print('Running without profile')
        #We are adding the argument in a copy of the actual list to avoid modify it now.
        myargs = good_args.copy()
        if arg:
            myargs.insert(-1, arg)
        subprocess.call(myargs)
        answer = input('Did %s run correctly? [y]/n ' % program)
        if answer in ['n', 'N']:
            bad_args.append(arg)
        elif arg:
            good_args.insert(-1, arg)
        print('\n')
    # Don't include 'firejail', '--noprofile', or program name in arguments
    good_args = good_args[2:-1]

    return good_args, bad_args


def main():
    try:
        profile_path = sys.argv[1]
        program = sys.argv[2]
    except IndexError:
        print('USAGE: jail_prober.py <PROFILE-PATH> <PROGRAM>')
        sys.exit()
    # Quick error check and extract arguments
    check_params(profile_path)
    profile = get_args(profile_path)
    all_args = arg_converter(profile, 'to_commandline')
    # Find out which profile options break the program when running in firejail
    good_args, bad_args = run_firejail(program, all_args)

    good_args = arg_converter(good_args, 'to_profile')
    bad_args = arg_converter(bad_args, 'to_profile')

    print('\n###########################')
    print('Debugging completed.')
    print(
        'Please copy the following and report it to the Firejail development',
        'team on GitHub at %s \n\n' %
        'https://github.com/netblue30/firejail/issues')

    subprocess.call(['firejail', '--version'])

    print('These profile options break the program.')
    print('```')
    for item in bad_args:
        print(item)
    print('```\n\n\n')

    print('This is a minimal working profile:')
    print('```')
    for item in good_args:
        print(item)
    print('```')


if __name__ == '__main__':
    main()
