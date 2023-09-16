# Contributing Guidelines

Contributions are welcome via GitHub Pull Requests.

Any type of contribution is welcome; from new features, bug fixes, tests and documentation improvements.

## How to Contribute

1. Open an issue
2. Fork this repository, develop, and test your changes.
3. Submit a pull request referencing the issue.

### Technical Requirements

When submitting a PR make sure that it:

- Must pass CI jobs for linting and unit tests. (Automatically done by the CI/CD pipeline).
- Any change to a Helm template (especially new templates) must be covered by unit tests.
- Any change to a values file or template logic must be documented in values.yaml and in chart documentation.
