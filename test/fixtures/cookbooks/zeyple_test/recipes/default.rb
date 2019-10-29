package value_for_platform_family(
  %w(arch debian) => %w(mailutils),
  %w(rhel) => %w(mailx),
)

execute('date | mail -s test root && sleep 2') do
  # XXX: `sleep 2` to let Postfix process the email
  # XXX: restart Postfix to make sure the new config is loaded
  notifies :restart, 'service[postfix]', :before
end
