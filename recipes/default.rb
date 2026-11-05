#
# Cookbook:: zeyple
# Recipe:: default
#

# Plug Zeyple into the postfix cookbook's resource, which another cookbook (e.g. sanity) may have declared already:
# include this recipe after it so they share it, otherwise it's declared here
postfix = edit_resource(:postfix, 'default')
main_settings = postfix.main_settings.to_h
master_settings = postfix.master_settings.to_h

# Postfix takes a single content_filter, so don't replace another one: chain it after Zeyple instead
next_content_filter = node['zeyple']['next_content_filter'].to_s
content_filters = [
  main_settings['content_filter'].to_s,
  node.dig('postfix', 'main', 'content_filter').to_s, # legacy attribute, still read by the postfix cookbook
]
content_filters << shell_out('postconf', '-h', 'content_filter').stdout.strip if ::File.exist?('/usr/sbin/postconf')
content_filters.each do |content_filter|
  next if ['', 'zeyple', next_content_filter].include?(content_filter)
  raise "Postfix's content_filter is already #{content_filter}: set node['zeyple']['next_content_filter'] " \
        "to #{content_filter} to pass the emails on to it after Zeyple"
end

postfix.master_settings(
  master_settings.merge(
    'zeyple' => {
      # zeyple    unix  -       n       n       -       -       pipe
      'active' => true,
      'order' => 600,
      'type' => 'unix',
      'unpriv' => false,
      'chroot' => false,
      'command' => 'pipe',
      'args' => ["user=#{node['zeyple']['user']} argv=#{node['zeyple']['script']} ${recipient}"],
    },
    "#{node['zeyple']['relay']['host']}:#{node['zeyple']['relay']['port']}" => {
      # inet  n       -       n       -       10      smtpd
      'active' => true,
      'order' => 600,
      'type' => 'inet',
      'private' => false,
      'chroot' => false,
      'maxproc' => '10',
      'command' => 'smtpd',
      # one argument per line since master.cf continuation lines must be indented
      'args' => [
        "-o content_filter=#{next_content_filter}",
        '-o receive_override_options=no_unknown_recipient_checks,no_header_body_checks,no_milters',
        '-o smtpd_helo_restrictions=',
        '-o smtpd_client_restrictions=',
        '-o smtpd_sender_restrictions=',
        '-o smtpd_recipient_restrictions=permit_mynetworks,reject',
        '-o mynetworks=127.0.0.0/8,[::1]/128',
        '-o smtpd_authorized_xforward_hosts=127.0.0.0/8,[::1]/128',
      ],
    },
  ),
)

postfix.main_settings(
  main_settings.merge(
    'content_filter' => 'zeyple',
    # run Zeyple once per recipient so an error for one recipient doesn't affect the others
    'zeyple_destination_recipient_limit' => 1,
  ),
)

# the package doesn't touch the Postfix configuration: the settings above plug Zeyple in
apt_repository 'zeyple' do
  uri node['zeyple']['apt']['uri']
  distribution node['zeyple']['apt']['distribution']
  components node['zeyple']['apt']['components']
  key node['zeyple']['apt']['key']
end

# the package installs the script as root so the zeyple user, which handles the emails, can't modify it
# (it replaces the copy older versions of this cookbook put at the same path);
# it also ships /etc/zeyple.conf as a conffile, which the template below then manages:
# apt_package keeps the existing file on upgrade (--force-confold)
# the package also creates the zeyple system user and group
package 'zeyple' do
  version node['zeyple']['package_version']
  action node['zeyple']['package_version'] ? :install : :upgrade
end

directory "#{node['zeyple']['data_dir']}/keys" do
  owner node['zeyple']['user']
  group node['zeyple']['group']
  mode '0700'
end

node['zeyple']['gpg']['keys'].each do |key|
  command_prefix = "gpg --homedir #{node['zeyple']['data_dir']}/keys --keyserver #{node['zeyple']['gpg']['server']}"

  execute "#{command_prefix} --recv-keys #{key}" do
    user node['zeyple']['user']
    group node['zeyple']['group']
    not_if "#{command_prefix} --list-keys #{key}", user: node['zeyple']['user']
  end
end

# the config belongs to root so the zeyple user can't modify it
template node['zeyple']['config_file'] do
  owner 'root'
  group 'root'
  mode '0644'
end

# like the package (and mail.log): the log names the recipients, so only the adm group may read it
file node['zeyple']['log_file'] do
  owner node['zeyple']['user']
  group 'adm'
  mode '0640'
end
