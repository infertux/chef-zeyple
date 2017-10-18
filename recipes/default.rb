#
# Cookbook Name:: zeyple
# Recipe:: default
#

node['zeyple']['dependencies'].each { |pkg| package pkg }

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

execute 'verify checksum' do
  cwd ::File.dirname(node['zeyple']['script'])
  command %(echo "#{node['zeyple']['upstream']['checksum']}  #{node['zeyple']['script']}" | sha256sum -c -)
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

ruby_block 'ensure that master.cf has the configuration' do # ~FC014
  block do
    master = Chef::Util::FileEdit.new('/etc/postfix/master.cf')
    master.insert_line_if_no_match(/zeyple/, <<-CONF.gsub(/^[ ]{2}/, ''))

  zeyple    unix  -       n       n       -       -       pipe
    user=#{node['zeyple']['user']} argv=#{node['zeyple']['script']} \${recipient}

  #{node['zeyple']['relay']['host']}:#{node['zeyple']['relay']['port']} inet  n       -       n       -       10      smtpd
    -o content_filter=
    -o receive_override_options=no_unknown_recipient_checks,no_header_body_checks,no_milters
    -o smtpd_helo_restrictions=
    -o smtpd_client_restrictions=
    -o smtpd_sender_restrictions=
    -o smtpd_recipient_restrictions=permit_mynetworks,reject
    -o mynetworks=127.0.0.0/8
    -o smtpd_authorized_xforward_hosts=127.0.0.0/8
    CONF

    master.write_file
  end
end

ruby_block 'ensure that zeyple is enabled and reload postfix if needed' do
  block do
    line = 'content_filter = zeyple'

    main = Chef::Util::FileEdit.new('/etc/postfix/main.cf')
    main.insert_line_if_no_match(/\A#{line}/, "\n#{line}")
    main.write_file

    # TODO: is it worth depending on postfix cookbook and use `notifies :reload, 'service[postfix]'`?
    Mixlib::ShellOut.new('postfix reload').run_command if main.file_edited?
  end
end
