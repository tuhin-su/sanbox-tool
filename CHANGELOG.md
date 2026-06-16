# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Created [CHANGELOG.md](file:///home/master/Desktop/sanbox-tool/CHANGELOG.md) to keep track of project modifications.

### Fixed
- **DNS & SSL Networking inside Sandbox:** Patched [sanbox](file:///home/master/Desktop/sanbox-tool/sanbox) script to bind-mount the host's DNS configuration and SSL certificates (`resolv.conf`, `hosts`, `nsswitch.conf`, `ssl`, `pki`, `ca-certificates`) using `--ro-bind-try`. This fixes all internet connection, name resolution, and HTTPS/SSL errors inside the sandbox.
- **Installer Deletion Vulnerability:** Removed a highly dangerous command from [install.sh](file:///home/master/Desktop/sanbox-tool/install.sh) (`rm -rf ../sanbox-tool`) that would delete the user's source code directory upon installation.
