#
# Cookbook Name:: zeyple
# Attributes:: default
#

# You must configure these attributes

default['zeyple']['gpg']['keys'] = []

# You might configure these attributes (defaults are fine)

default['zeyple']['dependencies'] = %w(gnupg sudo)

case node['platform_family']
when 'rhel'
  default['zeyple']['dependencies'] << 'pygpgme'
else
  default['zeyple']['dependencies'] << 'python-gpgme'
end

default['zeyple']['user'] = 'zeyple'
default['zeyple']['config_file'] = '/etc/zeyple.conf'
default['zeyple']['data_dir'] = '/var/lib/zeyple'
default['zeyple']['log_file'] = '/var/log/zeyple.log'
default['zeyple']['relay']['host'] = 'localhost'
default['zeyple']['relay']['port'] = '10026'
default['zeyple']['gpg']['server'] = 'hkp://keys.gnupg.net'
default['zeyple']['script'] = '/usr/sbin/zeyple'

default['zeyple']['upstream']['url'] = 'https://raw.githubusercontent.com/infertux/zeyple/v1.1.0/zeyple/zeyple.py'
default['zeyple']['upstream']['checksum'] = 'ddefceac6a47b31601340b5d01410fee2f2a855f111df837656f4f5166b4186b'
