package_names = {
  'debian' => %w(mailutils),
  'centos' => %w(mailx),
}

package package_names.fetch(node['platform_family'])

execute('date | mail -s test root && sleep 2') do
  # XXX: `sleep 2` to let Postfix process the email
  # XXX: restart Postfix to make sure the new config is loaded
  notifies :restart, 'service[postfix]', :before
end
