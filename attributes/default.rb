#
# Cookbook:: zeyple
# Attributes:: default
#

# You must configure these attributes

default['zeyple']['gpg']['keys'] = %w()

# You might configure these attributes (defaults are fine)

# Zeyple's APT repository, its single suite serves Debian and Ubuntu (the package is Architecture: all)
default['zeyple']['apt']['uri'] = 'https://deb.cyberbits.eu/zeyple'
default['zeyple']['apt']['distribution'] = 'stable'
default['zeyple']['apt']['components'] = %w(main)
default['zeyple']['apt']['key'] = 'https://deb.cyberbits.eu/0x580D9B7340D7A21A.key'
# nil keeps the package up to date, set a version (e.g. '3.0.0') to pin it
default['zeyple']['package_version'] = nil

default['zeyple']['user'] = 'zeyple'
default['zeyple']['config_file'] = '/etc/zeyple.conf'
default['zeyple']['data_dir'] = '/var/lib/zeyple'
default['zeyple']['log_file'] = '/var/log/zeyple.log'
default['zeyple']['relay']['host'] = `wc -l < /proc/net/if_inet6`.chomp == '0' ? '127.0.0.1' : 'localhost'
default['zeyple']['relay']['port'] = '10026'
# keyserver.ubuntu.com keeps the user IDs (email addresses) Zeyple needs to match recipients,
# keys.openpgp.org only keeps the verified ones
default['zeyple']['gpg']['server'] = 'hkps://keyserver.ubuntu.com'
# where the package installs the script
default['zeyple']['script'] = '/usr/sbin/zeyple'

default['zeyple']['version'] = '3.0.0'

default['zeyple']['upstream']['selinux']['url'] = "https://raw.githubusercontent.com/infertux/zeyple/v#{node['zeyple']['version']}/selinux/zeyple.te"
default['zeyple']['upstream']['selinux']['checksum'] = '2044cb49b77fd183f9d581135ef6998d3e55161275c9cb16ec8f0e0ef8a21453'
