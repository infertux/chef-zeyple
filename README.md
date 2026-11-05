Zeyple Cookbook
===============
[![Cookbook](https://img.shields.io/cookbook/v/zeyple.svg)](https://supermarket.chef.io/cookbooks/zeyple)
[![Build Status](https://github.com/infertux/chef-zeyple/actions/workflows/cookbook.yml/badge.svg)](https://github.com/infertux/chef-zeyple/actions/workflows/cookbook.yml)

This cookbook installs [Zeyple](https://github.com/infertux/zeyple) from its [APT repository](https://deb.cyberbits.eu/zeyple/) and configures it with Postfix.

Requirements
------------

- Chef or Cinc 18 or later
- Debian 12, Debian 13, Ubuntu 24.04 or Ubuntu 26.04 (the platforms tested in CI)
- Postfix (installed with the [postfix cookbook](https://supermarket.chef.io/cookbooks/postfix) 7.0 or later)

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
  "package_version": "3.0.0-1"
}
```

By default Zeyple drops emails to recipients without a key, like the package's default configuration. To send them unencrypted instead:

```json
"zeyple": {
  "force_encrypt": false
}
```

Postfix takes a single `content_filter`, and Zeyple needs it, so the recipe stops if another filter is already set. To keep that filter, pass the emails on to it after Zeyple:

```json
"zeyple": {
  "next_content_filter": "smtp-amavis:[127.0.0.1]:10024"
}
```

Add the `zeyple` recipe to your run list:

```json
"recipe[zeyple]"
```

The recipe plugs Zeyple into the postfix cookbook's `postfix 'default'` resource with `edit_resource`, declaring it if needed.
If another cookbook also configures Postfix with that resource (e.g. [sanity](https://github.com/infertux/chef-sanity)), include the `zeyple` recipe after it so they share the same resource.

License
-------
MIT
