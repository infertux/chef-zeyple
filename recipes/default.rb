#
# Cookbook Name:: zeyple
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

remote_file node['zeyple']['script'] do
  source node['zeyple']['upstream']['url']
  owner node['zeyple']['user']
  group node['zeyple']['user']
  mode '0700'
  checksum node['zeyple']['upstream']['checksum']
end

template node['zeyple']['config_file'] do
  owner node['zeyple']['user']
  group node['zeyple']['user']
  mode '0400'
end

file node['zeyple']['log_file'] do
  owner node['zeyple']['user']
  group node['zeyple']['user']
  mode '0600'
end

execute 'ensure that master.cf has the configuration' do
  user 'root'
  group 'root'
  not_if "grep -E '^zeyple' /etc/postfix/master.cf"
  command <<~CONF
    cat <<EOH >> /etc/postfix/master.cf
    zeyple    unix  -       n       n       -       -       pipe
      user=#{node['zeyple']['user']} argv=#{node['zeyple']['script']} \${recipient}

    #{node['zeyple']['relay']['host']}:#{node['zeyple']['relay']['port']} inet  n       -       n       -       10      smtpd
      -o content_filter=
      -o receive_override_options=no_unknown_recipient_checks,no_header_body_checks,no_milters
      -o smtpd_helo_restrictions=
      -o smtpd_client_restrictions=
      -o smtpd_sender_restrictions=
      -o smtpd_recipient_restrictions=permit_mynetworks,reject
      -o mynetworks=127.0.0.0/8,[::1]/128
      -o smtpd_authorized_xforward_hosts=127.0.0.0/8,[::1]/128
    EOH
    CONF
end

content_filter = 'content_filter = zeyple'

execute 'ensure that zeyple is enabled and reload postfix if needed' do
  user 'root'
  group 'root'
  not_if "grep -E '^#{content_filter}' /etc/postfix/main.cf"
  command "echo '#{content_filter}' >> /etc/postfix/main.cf"
  notifies :reload, 'service[postfix]'
end

service 'postfix' do
  action :nothing
end
