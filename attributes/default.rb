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

default['zeyple']['upstream']['url'] = "https://raw.githubusercontent.com/infertux/zeyple/master/zeyple/zeyple.py"
default['zeyple']['upstream']['checksum'] = 'fed33f55b5169425293a340cf02b4b2b5ee44f4ec2bdd1c707ea7031bd66b215'
