#
# Cookbook Name:: zeyple
# Attributes:: default
#

# You must configure these attributes

default['zeyple']['gpg']['keys'] = []

# You might configure these attributes (defaults are fine)

default['zeyple']['user'] = 'zeyple'
default['zeyple']['dependencies'] = %w(gnupg python-gpgme sudo)
default['zeyple']['config_file'] = '/etc/zeyple.conf'
default['zeyple']['data_dir'] = '/var/lib/zeyple'
default['zeyple']['log_file'] = '/var/log/zeyple.log'
default['zeyple']['relay']['host'] = 'localhost'
default['zeyple']['relay']['port'] = '10026'
default['zeyple']['gpg']['server'] = 'hkp://keys.gnupg.net'
default['zeyple']['script'] = '/usr/sbin/zeyple'

default['zeyple']['upstream']['url'] = 'https://raw.githubusercontent.com/infertux/zeyple/master/zeyple/zeyple.py'
default['zeyple']['upstream']['checksum'] = '078a1101b65bfdaba3451ade8ea5841e9e6b3606b4ea468c68bf97c794fb693f'
