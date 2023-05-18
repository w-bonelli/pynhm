# Releasing `pywatershed`

This document describes release procedures for `pywatershed`. Since development occurs on this repository's `main` branch, releases entail taking a snapshot of the state of `main` for distribution.

## Triggering a release

The automated release workflow is defined in `.github/workflows/release.yml`. The workflow is configured to run whenever a release branch is pushed to the `EC-USGS/pywatershed` repository. A release branch is any branch whose name matches pattern `v{major}.{minor}.{patch}` (note the leading `v`).

To release a new version of `pywatershed`:

1. Create a release candidate branch from some preexisting revision on `main`. The branch's name must begin with `v` followed by the semantic version number as described above. Manually updating the version number in `version.py` is not required.
2. Push the branch to the `EC-USGS/pywatershed` repository. This will trigger a job to checkout the release, auto-update version number in `version.py` to match the release branch's name, build and check the package, auto-generate a changelog, upload the package and changelog as artifacts, and create a draft GitHub release.
3. If the distribution passes manual inspection, the draft release can be published via the GitHub UI or CLI. This will trigger a job to tag the snapshot revision with the semantic version number and publish the distribution to PyPI. A final job updates `version.py` to match the just-released major version with incremented minor version number, then opens a draft PR into `main`.

### Versioning conventions

Version numbers follow [semantic versioning](https://semver.org/) convention `major.minor.patch`. Release tags, unlike branches, do *not* include an initial `v`, as is common in many other projects.