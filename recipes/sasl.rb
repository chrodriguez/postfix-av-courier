package "sasl2-bin" 

package "mawk"

ruby_block "check_if_chrooted_true" do
  block do
    node.set[:postfix][:chrooted] = true
  end
  only_if "grep '^smtp ' /etc/postfix/master.cf | grep smtpd | awk  '{print $5}' | egrep -q '(-|y)'"
  notifies :create, "template[/etc/default/saslauthd]"
  subscribes :create, "template[/etc/postfix/master.cf]"
end

ruby_block "check_if_chrooted_false" do
  block do
    node.set[:postfix][:chrooted] = false
  end
  not_if "grep '^smtp ' /etc/postfix/master.cf | grep smtpd | awk  '{print $5}' | egrep -q '(-|y)'"
  notifies :create, "template[/etc/default/saslauthd]"
  subscribes :create, "template[/etc/postfix/master.cf]"
end

template "/etc/default/saslauthd"  do
    action :nothing
    source "sasl/saslauthd.erb"
    owner "root"
    group "root"
    variables(
      :chrooted => lambda do
        node[:postfix][:chrooted] 
      end
    )
    mode "0644"
end

service "saslauthd" do
  action [ :enable, :restart ]
  subscribes :restart, resources( 
     :template => "/etc/default/saslauthd"
  )
end

package "libpam-ldap"

template node[:postfix][:libpam][:conf] do
  source "ldap/pam-ldap.conf.erb"
  owner "root"
  group "root"
  variables(
    :ldap_auth => ldap_auth,
    :ldap_host => ldap_host
  )
  mode "0644"
end

file node[:postfix][:libpam][:secret] do
  owner "root"
  group "root"
  mode "0600"
  content ldap_auth['password']
  not_if { ldap_auth.empty? }
end

file node[:postfix][:libpam][:smtp] do
  content <<-EOS
auth required pam_ldap.so
account required pam_ldap.so
session required pam_ldap.so
  EOS
  owner "root"
  group "root"
  mode "0644"

end

group node[:postfix][:sasl][:group] do
  members node[:postfix][:user]
end

file node[:postfix][:sasl][:conf] do
  content <<-EOS
pwcheck_method: saslauthd
mech_list: plain login
  EOS
  owner "root"
  group "root"
  mode "0644"
end
