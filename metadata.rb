name             'zeyple'
maintainer       'Cédric Félizard'
maintainer_email 'cedric@felizard.fr'
license          'MIT'
description      'Installs/Configures Zeyple'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url       'https://github.com/infertux/chef-zeyple'
issues_url       'https://github.com/infertux/chef-zeyple/issues'
version          '1.2.2'
chef_version     '>= 13.0'

supports 'debian'
supports 'centos'
supports 'ubuntu'

depends 'postfix', '>= 5.2'
