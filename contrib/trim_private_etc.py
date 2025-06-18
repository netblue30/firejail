#!/usr/bin/env python3

import re
import sys
import os

# C header file containing the char* arrays (relative to the current script)
etc_groups_file = os.path.join(os.path.dirname(__file__), "../src/include/etc_groups.h")
default_group = "etc_list"


# Regex pattern to capture the array name and its content (in one string).
default_group_array_pattern = re.compile(
    r"static\s+char\s*\*\s*"  # Matches "static char *"
    r"etc_list\s*\[.*?\]\s*=\s*\{"  # Matches default group "etc_list"
    r"(.*?)"  # Non-greedily captures the entire content (group 1)
    r"NULL\s*,?\s*\}\s*;",  # Matches the closing "NULL };"
    re.DOTALL | re.MULTILINE,
)


# Regex pattern to capture the array name and its content (in one string).
etc_group_array_pattern = re.compile(
    r"static\s+char\s*\*\s*"  # Matches "static char *"
    r"etc_group_(\w+)\s*\[.*?\]\s*=\s*\{"  # Captures the array name (group 1)
    r"(.*?)"  # Non-greedily captures the entire content (group 2)
    r"NULL\s*,?\s*\}\s*;",  # Matches the closing "NULL };"
    re.DOTALL | re.MULTILINE,
)

# Regex to find all strings inside double-quotes.
element_pattern = r'"(.*?)"'


def c_array_to_dict(c_code: str):
    """
    Finds all C-style char* arrays in a string and converts them
    into a single Python dictionary.
    """
    # The dictionary to store all our results
    default_group = []
    etc_groups = {}

    default_group_array = default_group_array_pattern.search(c_code)
    default_group_content = default_group_array.group(1) if default_group_array else ""
    default_group.extend(re.findall(element_pattern, default_group_content))

    etc_group_arrays = etc_group_array_pattern.findall(c_code)

    for array_name, array_content in etc_group_arrays:

        # Extract the elements from the array content (to exclude comments, newlines, etc)
        array_elements = re.findall(element_pattern, array_content)
        etc_groups[array_name] = array_elements

    return default_group, etc_groups


def optimize_etc(private_etc_line: str) -> str:

    private_etc = [e.strip() for e in private_etc_line.split(",")]

    with open(etc_groups_file, "r") as etc_groups_header_file:
        default_group, etc_groups = c_array_to_dict(etc_groups_header_file.read())

    new_private_etc = private_etc.copy()

    # Remove automatically included private-etc items from explicit definitions
    for item in default_group:
        if item in new_private_etc:
            new_private_etc.remove(item)

    for group in etc_groups:

        # If items of a group are are all present in private-etc
        if set(etc_groups[group]).issubset(set(private_etc)):
            # Append that group
            new_private_etc.append(f"@{group}")

            # Remove all items from private-etc that are part of this group
            for item in etc_groups[group]:
                new_private_etc.remove(item)

    return ",".join(sorted(new_private_etc))


def main():

    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <input_file>")
        sys.exit(1)

    with open(sys.argv[1], "r") as profile_file:
        profile = profile_file.read()

    if "private-etc" not in profile:
        print("No private-etc command found in the profile.")
        return ""

    private_etc_pattern = re.compile(r"^private-etc\s(.*?)(?:\s*#.*)?$", re.MULTILINE)

    profile_private_etc = (private_etc_pattern.findall(profile))[0].strip()

    print("private-etc", optimize_etc(profile_private_etc))


if __name__ == "__main__":
    main()
