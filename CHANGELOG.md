Zeyple CHANGELOG
================

## v3.0.0
- Install Zeyple 3.0.0 from its APT repository (https://deb.cyberbits.eu/zeyple/) instead of downloading the script (still at `/usr/sbin/zeyple`); the `dependencies` and `upstream.script` attributes are gone
- Zeyple 3.0.0 requires Python 3 and `python3-gpg` instead of `python-gpgme`
- Fetch keys from keyserver.ubuntu.com since the SKS keyserver pool behind keys.gnupg.net is gone
- Fix the reinjection service in `master.cf`, whose unindented lines kept Postfix from starting
- Set `zeyple_destination_recipient_limit = 1` so Postfix runs Zeyple once per recipient
- Install the Zeyple script and config as root so the zeyple user, which handles the emails, can't modify them
- Make the log `zeyple:adm` 0640 like the package does, so the two don't flip it on every run
- Set `force_encrypt = 1` by default like the package (new `force_encrypt` attribute): recipients without a key no longer get unencrypted emails
- Stop instead of replacing another Postfix `content_filter`, and chain it after Zeyple with the new `next_content_filter` attribute
- Let the package create the zeyple user and group instead of the recipe
- Drop the `selinux` recipe and the `version` and `upstream.selinux` attributes: Debian and Ubuntu use AppArmor, not SELinux
- Test on Debian 12, Debian 13, Ubuntu 24.04 and Ubuntu 26.04 with GitHub Actions instead of Travis CI

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
