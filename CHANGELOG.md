Zeyple CHANGELOG
================

## v3.0.0
- Install Zeyple 2.0.0, which requires Python 3 and `python3-gpg` instead of `python-gpgme`
- Fetch keys from keyserver.ubuntu.com since the SKS keyserver pool behind keys.gnupg.net is gone
- Fix the reinjection service in `master.cf`, whose unindented lines kept Postfix from starting
- Set `zeyple_destination_recipient_limit = 1` so Postfix runs Zeyple once per recipient
- Test on Debian 12, Debian 13 and Ubuntu 24.04 with GitHub Actions instead of Travis CI

## v2.0.0
- Require Chef 18 and depend on the postfix cookbook ~> 6.0
- Drop CentOS support
- Test with Test Kitchen and Docker (kitchen-dokken) instead of Vagrant

## v1.2.2
- Update cookbook for Zeyple 1.2.2

## v1.2.1
- Update cookbook for Zeyple 1.2.1

## v1.1.0
- Update checksum for Zeyple 1.1.0

## v1.0.0
- Initial release
