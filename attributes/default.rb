#
# Cookbook:: zeyple
# Attributes:: default
#

# You must configure these attributes

default['zeyple']['gpg']['keys'] = %w()

# You might configure these attributes (defaults are fine)

default['zeyple']['dependencies'] = %w(gnupg python3-gpg sudo)
default['zeyple']['dependencies'] |= %w(dirmngr) unless platform_family?('rhel')

default['zeyple']['user'] = 'zeyple'
default['zeyple']['config_file'] = '/etc/zeyple.conf'
default['zeyple']['data_dir'] = '/var/lib/zeyple'
default['zeyple']['log_file'] = '/var/log/zeyple.log'
default['zeyple']['relay']['host'] = `wc -l < /proc/net/if_inet6`.chomp == '0' ? '127.0.0.1' : 'localhost'
default['zeyple']['relay']['port'] = '10026'
# keyserver.ubuntu.com keeps the user IDs (email addresses) Zeyple needs to match recipients,
# keys.openpgp.org only keeps the verified ones
default['zeyple']['gpg']['server'] = 'hkps://keyserver.ubuntu.com'
default['zeyple']['script'] = '/usr/sbin/zeyple'

default['zeyple']['version'] = '2.0.0'

default['zeyple']['upstream']['script']['url'] = "https://raw.githubusercontent.com/infertux/zeyple/v#{node['zeyple']['version']}/zeyple/zeyple.py"
default['zeyple']['upstream']['script']['checksum'] = '6b7576009523687a5e6d1145135c04566fddf893e6d669c060ec2826afa3a29a'

default['zeyple']['upstream']['selinux']['url'] = "https://raw.githubusercontent.com/infertux/zeyple/v#{node['zeyple']['version']}/selinux/zeyple.te"
default['zeyple']['upstream']['selinux']['checksum'] = '2044cb49b77fd183f9d581135ef6998d3e55161275c9cb16ec8f0e0ef8a21453'
