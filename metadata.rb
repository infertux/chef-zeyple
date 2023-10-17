name             'zeyple'
maintainer       'Cédric Félizard'
maintainer_email 'cedric@felizard.fr'
license          'MIT'
description      'Installs/Configures Zeyple'
source_url       'https://github.com/infertux/chef-zeyple'
issues_url       'https://github.com/infertux/chef-zeyple/issues'
version          '2.0.0'
chef_version     '>= 18.0'

supports 'debian'
supports 'ubuntu'

depends 'postfix', '~> 6.0'
