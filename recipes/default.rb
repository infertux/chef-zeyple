#
# Cookbook:: zeyple
# Recipe:: default
#

package node['zeyple']['dependencies']

user node['zeyple']['user'] do
  system true
  shell '/usr/sbin/nologin'
  home node['zeyple']['data_dir']
  manage_home true
end

directory "#{node['zeyple']['data_dir']}/keys" do
  owner node['zeyple']['user']
  group node['zeyple']['user']
  mode '0700'
end

node['zeyple']['gpg']['keys'].each do |key|
  command_prefix = "gpg --homedir #{node['zeyple']['data_dir']}/keys --keyserver #{node['zeyple']['gpg']['server']}"

  execute "#{command_prefix} --recv-keys #{key}" do
    user node['zeyple']['user']
    group node['zeyple']['user']
    not_if "#{command_prefix} --list-keys #{key}", user: node['zeyple']['user'], group: node['zeyple']['user']
  end
end

# the script and config belong to root so the zeyple user, which handles the emails, can't modify them
remote_file node['zeyple']['script'] do
  source node['zeyple']['upstream']['script']['url']
  owner 'root'
  group 'root'
  mode '0755'
  checksum node['zeyple']['upstream']['script']['checksum']
end

template node['zeyple']['config_file'] do
  owner 'root'
  group 'root'
  mode '0644'
end

file node['zeyple']['log_file'] do
  owner node['zeyple']['user']
  group node['zeyple']['user']
  mode '0600'
end

include_recipe 'postfix::default'

node.default['postfix']['master']['zeyple'] = {
  # zeyple    unix  -       n       n       -       -       pipe
  active: true,
  order: 600,
  type: 'unix',
  unpriv: false,
  chroot: false,
  command: 'pipe',
  args: ["user=#{node['zeyple']['user']} argv=#{node['zeyple']['script']} ${recipient}"],
}

node.default['postfix']['master']["#{node['zeyple']['relay']['host']}:#{node['zeyple']['relay']['port']}"] = {
  # inet  n       -       n       -       10      smtpd
  active: true,
  order: 600,
  type: 'inet',
  private: false,
  chroot: false,
  maxproc: '10',
  command: 'smtpd',
  # one argument per line since master.cf continuation lines must be indented
  args: [
    '-o content_filter=',
    '-o receive_override_options=no_unknown_recipient_checks,no_header_body_checks,no_milters',
    '-o smtpd_helo_restrictions=',
    '-o smtpd_client_restrictions=',
    '-o smtpd_sender_restrictions=',
    '-o smtpd_recipient_restrictions=permit_mynetworks,reject',
    '-o mynetworks=127.0.0.0/8,[::1]/128',
    '-o smtpd_authorized_xforward_hosts=127.0.0.0/8,[::1]/128',
  ],
}

node.default['postfix']['main']['content_filter'] = 'zeyple'
# run Zeyple once per recipient so an error for one recipient doesn't affect the others
node.default['postfix']['main']['zeyple_destination_recipient_limit'] = 1

include_recipe "#{cookbook_name}::selinux" if File.exist?('/sys/fs/selinux')
