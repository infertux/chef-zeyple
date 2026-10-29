control 'zeyple-1' do
  title 'Zeyple is installed and configured properly'
  impact 1.0

  describe user('zeyple') do
    it { should exist }
    its('groups') { should eq %w(zeyple) }
    its('home') { should eq '/var/lib/zeyple' }
    its('shell') { should include 'nologin' }
  end

  describe file('/etc/zeyple.conf') do
    it { should be_file }
    its('owner') { should eq 'root' }
    its('mode') { should cmp '0644' }
  end

  describe file('/var/log/zeyple.log') do
    it { should be_file }
    its('owner') { should eq 'zeyple' }
  end

  describe apt('https://deb.cyberbits.eu/zeyple') do
    it { should exist }
    it { should be_enabled }
  end

  describe package('zeyple') do
    it { should be_installed }
    its('version') { should cmp >= '3.0.0' }
  end

  describe file('/usr/sbin/zeyple') do
    it { should be_file }
    its('owner') { should eq 'root' }
    its('mode') { should cmp '0755' }
  end

  describe file('/etc/postfix/master.cf') do
    its('content') { should include 'argv=/usr/sbin/zeyple ${recipient}' }
    # the package's post-install script didn't append its own copy
    its('content') { should_not include '###BEGIN-ZEYPLE' }
  end

  describe command('postconf -h zeyple_destination_recipient_limit') do
    its('stdout') { should eq "1\n" }
  end

  describe command('ls -1 /var/lib/zeyple/keys/ | wc -l') do
    its('stdout') { should_not eq '0' }
  end

  describe port(10_026) do
    it { should be_listening }
    its('protocols') { should include 'tcp' }
    its('processes') { should eq %w(master) }
  end
end

control 'zeyple-2' do
  title 'Zeyple is working properly'
  desc 'Send test email then assert it was processed properly'
  impact 1.0

  describe file('/var/log/zeyple.log') do
    its('content') { should match(/INFO Recipient: root@\S+/) }
    its('content') { should match(/INFO Key ID: None/) }
    its('content') { should match(/INFO Message <[^>]+> sent/) }
  end
end
