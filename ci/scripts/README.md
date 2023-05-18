# Scripts

This document describes the utility scripts in this directory.

## Preparing for PRs

The `pull_request_prepare.py` script lints Python source code files by running `black` and `isort` on the `pywatershed` subdirectory. This script should be run before opening a pull request, as CI will fail if the code is not properly formatted. For instance, from the project root:

```shell
python ci/scripts/pull_request_prepare.py
```

## Updating version

The `update_version.py` script can be used to update version number in `pywatershed/version.py`. Currently this is the only place version information is embedded in this repository, but should this change, modifying this script to update/rewrite additional files should allow for easier versioning than manual editing. The script acquires a file lock to make sure only one process edits version files at any given time, hopefully preventing desynchronization.

If the script is run with no arguments, the version number is not changed &mdash; only updated timestamp comments are written. To set the version number, use the `--version` (short `-v`) option, e.g.:

```shell
python scripts/update_version.py -v 3.3.6
```

To get the current version number without writing any changes to the repository's files, use the `--get` (short `-g`) flag:

```shell
python scripts/update_version.py -g
```
