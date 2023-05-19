# Actions workflows

This document describes this project's GitHub Actions workflows.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Testing](#testing)
- [Releasing](#releasing)
  - [Versioning conventions](#versioning-conventions)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Testing

Two workflows run on PR and push events:

- `ci.yaml`: build and test `pywatershed`
- `ci_examples.yaml` test example notebooks

## Releasing

Development occurs on this repository's `main` branch. Releases are snapshots of `main`.

The release procedure is defined in `.github/workflows/release.yml`. It triggers when a release branch is pushed to the repo. Creating/pushing the release branch is the only manual step necessary.

To release a new version of `pywatershed`:

1. Create a release candidate branch from some revision on `main`. The branch's name must follow format `v{major}.{minor}.{patch}` (semantic version number with a leading 'v'). 
2. Push the branch. E.g. if this repo is an `upstream` remote, `git push -u upstream vx.y.z`. This starts a job which:
    - checks out the release branch
    - updates the version number in `pywatershed/version.py` to match the version in the branch name
    - builds and checks the package
    - generates a changelog
    - uploads the package and changelog as artifacts
    - drafts a GitHub release.
3. If the distribution looks good, the release can be published via GitHub UI or CLI. This starts jobs to:
    - tag the head of the release branch (snapshot of `main`) with the version number (with no leading 'v')
    - publish the distribution to PyPI.
    - update `pywatershed/version.py` to match the just-released major version, with minor version number incremented and patch number 0, then drafts a PR with these changes into `main`.

### Versioning conventions

Version numbers follow [semantic versioning](https://semver.org/) convention `major.minor.patch`. Release tags, unlike branches, don't include an initial `v`, as is common in some projects.