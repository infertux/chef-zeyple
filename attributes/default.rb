#
# Cookbook Name:: zeyple
# Attributes:: default
#

# You must configure these attributes

default['zeyple']['gpg']['keys'] = []

# You might configure these attributes (defaults are fine)

default['zeyple']['dependencies'] = %w[gnupg sudo]
default['zeyple']['dependencies'] << case node['platform_family']
                                     when 'rhel'
                                       'pygpgme'
                                     else
                                       'python-gpgme'
                                     end

default['zeyple']['user'] = 'zeyple'
default['zeyple']['config_file'] = '/etc/zeyple.conf'
default['zeyple']['data_dir'] = '/var/lib/zeyple'
default['zeyple']['log_file'] = '/var/log/zeyple.log'
default['zeyple']['relay']['host'] = 'localhost'
default['zeyple']['relay']['port'] = '10026'
default['zeyple']['gpg']['server'] = 'hkp://keys.gnupg.net'
default['zeyple']['script'] = '/usr/sbin/zeyple'

default['zeyple']['upstream']['url'] = 'https://raw.githubusercontent.com/infertux/zeyple/v1.2.1/zeyple/zeyple.py'
default['zeyple']['upstream']['checksum'] = '2e11fe4484b62a50a2fa04700b3e6753c05e28b515a85f05b5f86ee91fd4b33b'
