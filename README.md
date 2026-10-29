Zeyple Cookbook
===============
[![Cookbook](https://img.shields.io/cookbook/v/zeyple.svg)](https://supermarket.chef.io/cookbooks/zeyple)
[![Build Status](https://github.com/infertux/chef-zeyple/actions/workflows/cookbook.yml/badge.svg)](https://github.com/infertux/chef-zeyple/actions/workflows/cookbook.yml)

This cookbook installs [Zeyple](https://github.com/infertux/zeyple) from its [APT repository](https://deb.cyberbits.eu/zeyple/) and configures it with Postfix.

Requirements
------------

- Chef or Cinc 18 or later
- Debian 12, Debian 13, Ubuntu 24.04 or Ubuntu 26.04 (the platforms tested in CI)
- Postfix (installed with the [postfix cookbook](https://supermarket.chef.io/cookbooks/postfix))

Usage
-----

Configure the list of key IDs to encrypt email with:

```json
"zeyple": {
  "gpg": {
    "keys": ["0xEEC73D5809A98A9B"]
  }
}
```

Zeyple's package is kept up to date on every Chef run. To pin a version instead:

```json
"zeyple": {
  "package_version": "3.0.0"
}
```

Add the `zeyple` recipe to your run list:

```json
"recipe[zeyple]"
```

License
-------
MIT
