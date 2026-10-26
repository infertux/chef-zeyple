Zeyple Cookbook
===============
[![Cookbook](https://img.shields.io/cookbook/v/zeyple.svg)](https://supermarket.chef.io/cookbooks/zeyple)
[![Build Status](https://github.com/infertux/chef-zeyple/actions/workflows/cookbook.yml/badge.svg)](https://github.com/infertux/chef-zeyple/actions/workflows/cookbook.yml)

This cookbook downloads, installs and configures [Zeyple](https://github.com/infertux/zeyple).

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

Add the `zeyple` recipe to your run list:

```json
"recipe[zeyple]"
```

License
-------
MIT
