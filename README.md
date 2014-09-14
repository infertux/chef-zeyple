Zeyple Cookbook
===============
[![Cookbook](https://img.shields.io/cookbook/v/zeyple.svg)](https://supermarket.getchef.com/cookbooks/zeyple)
[![Build Status](https://travis-ci.org/infertux/chef-zeyple.svg?branch=master)](https://travis-ci.org/infertux/chef-zeyple)

This cookbook downloads, installs and configures Zeyple.

Requirements
------------

- Postfix

Usage
-----

Configure the list of key IDs to encrypt email with:

```json
"zeyple": {
  "gpg": {
    "keys": ["09A98A9B"]
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

