# Release guide

This document describes release procedures, conventions, and utilities for `pywatershed`.

This project follows the [git flow](https://nvie.com/posts/a-successful-git-branching-model/) branching model: development occurs on the `develop` branch, while `main` is reserved for the state of the latest release. Releases follow [semantic version](https://semver.org/) conventions. Minor and major releases will typically branch from `develop`, with patch releases branching from `main`.

The release procedure is mostly automated. The workflow is defined in `.github/workflows/release.yml` and triggers when a release or patch branch is pushed to this repo.

## Releasing `pywatershed`

To release a new version of `pywatershed`:

1. Create a release branch from `develop` or a patch branch from `main`.

    The branch's name must follow format `v{major}.{minor}.{patch}` ([semantic version](https://semver.org/) number with a leading 'v'). For instance, for a minor release, if this repo is an `upstream` remote and one's local `develop` is up to date with upstream `develop`, then from `develop` run `git switch -c vx.y.z`.

2. If this is a patch release, make changes/fixes locally. If this is a major or minor release, no changes are needed.

3. Push the branch to this repo. For instance, if this repo is an `upstream` remote: `git push -u upstream vx.y.z`. This starts a job to:

    - Check out the release branch
    - Update version number in `version.txt` and `pywatershed/version.py` to match the version in the branch name
    - Build and check the Python package
    - Generate a changelog since the last release
    - Prepend the changelog to the cumulative `HISTORY.md`
    - Upload the package and changelog as artifacts
    - Draft a PR against `main` with the updated version files and cumulative changelog. The cumulative `HISTORY.md` is version-controlled, release changelogs are not.

3. Inspect the package and changelog. If they look OK, merge the PR to `main`.

    **Note**: it is critical to *merge* the PR to `main`, not squash as is conventional for PRs on `develop`. Merging to `main` preserves commit history and ensures `develop` and `main` remain synchronized. Squashing will cause `develop` and `main` to diverge.

    Merging the PR will trigger another job to draft a [GitHub release](https://github.com/EC-USGS/pywatershed/releases). The release is not yet publicly visible at this point. The release notes are autofilled as the changelog since the last release.

4. Inspect the GitHub release. If needed, make any manual edits to the release notes. If the release looks good, publish it via GitHub UI or CLI. This tags the head of `main` with the release version number (**Note**: release tags, unlike branches, don't include an initial `v`, as is common in some projects) and triggers jobs to:

    - Publish the package to PyPI
    - Check out `main`
    - Update `version.txt` and `pywatershed/version.py` to match the just-released version, with a '+' appended to the version number in `version.txt` to indicate preliminary/development status.
    - Draft a PR against `develop` with the updated version files and the updates previously merged to `main`.

 5. Merge the PR to `develop`. As above, it is critical to *merge* the PR, not squash, to preserve history and keep `develop` and `main` from diverging. Subsequent development PRs may be squashed to `develop` as usual.

 ## Utility scripts

The automated release procedure uses a few scripts, located in `.github/scripts`:

- `update_version.py`
- `pull_request_prepare.py`

The former should never need to be run manually. The latter is convenient for formatting source files before opening PRs.

### Updating version numbers

The `update_version.py` script can be used to update version number in `pywatershed/version.py`. Currently this is the only place version information is embedded in this repository, but should this change, modifying this script to update/rewrite additional files should allow for easier versioning than manual editing. The script acquires a file lock to make sure only one process edits version files at any given time, hopefully preventing desynchronization.

If the script is run with no arguments, the version number is not changed &mdash; only updated timestamp comments are written. To set the version number, use the `--version` (short `-v`) option, e.g.:

```shell
python .github/scripts/update_version.py -v 3.3.6
```

To get the current version number without writing any changes to the repository's files, use the `--get` (short `-g`) flag:

```shell
python .github/scripts/update_version.py -g
```

### Preparing for PRs

The `pull_request_prepare.py` script lints Python source code files by running `black` and `isort` on the `pywatershed` subdirectory. This script should be run before opening a pull request, as CI will fail if the code is not properly formatted. For instance, from the project root:

```shell
python .github/scripts/pull_request_prepare.py
```
