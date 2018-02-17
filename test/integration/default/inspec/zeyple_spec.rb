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
    its('owner') { should eq 'zeyple' }
  end

  describe file('/var/log/zeyple.log') do
    it { should be_file }
    its('owner') { should eq 'zeyple' }
  end

  describe file('/usr/sbin/zeyple') do
    it { should be_file }
    its('owner') { should eq 'zeyple' }
    it { should be_executable.by('owner') }
  end

  describe command('ls -1 /var/lib/zeyple/keys/ | wc -l') do
    its('stdout') { should_not eq '0' }
  end

  describe port(10_026) do
    it { should be_listening }
    its('protocols') { should cmp %w(tcp tcp6) }
    its('processes') { should eq %w(master) }
  end
end
