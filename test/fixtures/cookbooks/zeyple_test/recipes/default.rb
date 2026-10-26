package value_for_platform_family(
  %w(arch debian) => %w(mailutils),
  %w(rhel) => %w(mailx),
)

execute('date | mail -s test root && sleep 2 && touch /var/tmp/zeyple_test_email_sent') do
  # XXX: `sleep 2` to let Postfix process the email
  # XXX: restart Postfix to make sure the new config is loaded
  notifies :restart, 'service[postfix]', :before
  # only send one email so the second converge is idempotent
  creates '/var/tmp/zeyple_test_email_sent'
end
