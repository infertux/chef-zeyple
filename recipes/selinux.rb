zeyple_te = "#{Chef::Config['file_cache_path']}/zeyple/zeyple.te"

# install dependencies to compile policy
package %w(checkpolicy policycoreutils policycoreutils-python)

directory File.dirname(zeyple_te)

remote_file zeyple_te do
  source node['zeyple']['upstream']['selinux']['url']
  owner node['zeyple']['user']
  group node['zeyple']['user']
  mode '0400'
  checksum node['zeyple']['upstream']['selinux']['checksum']
  notifies :run, 'execute[compile_selinux_policy]', :immediately
end

execute 'compile_selinux_policy' do
  action :nothing
  user 'root'
  group 'root'
  cwd File.dirname(zeyple_te)
  command 'checkmodule -Mmo zeyple.mod zeyple.te && semodule_package -m zeyple.mod -o zeyple.pp && (semodule -vr zeyple || true) && semodule -vi zeyple.pp'
end
