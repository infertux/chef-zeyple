#
# Cookbook Name:: zeyple
# Attributes:: default
#

# You must configure these attributes

default['zeyple']['gpg']['keys'] = %w()

# You might configure these attributes (defaults are fine)

default['zeyple']['dependencies'] = %w(gnupg sudo)
default['zeyple']['dependencies'] |= \
  case node['platform_family']
  when 'rhel'
    %w(pygpgme)
  else
    %w(python-gpgme dirmngr)
  end

default['zeyple']['user'] = 'zeyple'
default['zeyple']['config_file'] = '/etc/zeyple.conf'
default['zeyple']['data_dir'] = '/var/lib/zeyple'
default['zeyple']['log_file'] = '/var/log/zeyple.log'
default['zeyple']['relay']['host'] = 'localhost'
default['zeyple']['relay']['port'] = '10026'
default['zeyple']['gpg']['server'] = 'hkp://keys.gnupg.net'
default['zeyple']['script'] = '/usr/sbin/zeyple'

default['zeyple']['upstream']['url'] = 'https://raw.githubusercontent.com/infertux/zeyple/v1.2.2/zeyple/zeyple.py'
default['zeyple']['upstream']['checksum'] = '5f0671fd98e791b600dbb652e83acbcc5ecaede0da4758c5e26ea7094335ab58'
