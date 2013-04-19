#
# Cookbook Name:: amavis
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#
%w(
  courier-authdaemon
  courier-authlib
  courier-authlib-ldap
  courier-authlib-userdb
  courier-base
  courier-imap
  courier-imap-ssl
  courier-ldap
  courier-maildrop
  courier-pop
  courier-pop-ssl
  courier-ssl
  ).each do |p|
    package p
  end

if node[:postfix][:virtual_user][:enabled] 
  group node[:postfix][:virtual_user][:groupname] do
    gid node[:postfix][:virtual_user][:gid]
  end

  user node[:postfix][:virtual_user][:username] do
    uid node[:postfix][:virtual_user][:uid]
    gid node[:postfix][:virtual_user][:groupname]
    home node[:postfix][:virtual_user][:home]
    shell node[:postfix][:virtual_user][:shell]
  end
end

service "courier-authdaemon" 
service "courier-imap" 
service "courier-imap-ssl" 
service "courier-pop" 
service "courier-pop-ssl" 

ssl_certificate = "#{node[:postfix][:courier][:ssl][:cert_path]}/private/courier_formatted_certificate.pem"


certificate_manage node[:postfix][:ssl][:databag_item] do
  cert_path node[:postfix][:courier][:ssl][:cert_path]
  cert_file node[:postfix][:courier][:ssl][:cert_file]
  key_file node[:postfix][:courier][:ssl][:key_file]
  chain_file node[:postfix][:courier][:ssl][:chain_file]
end

bash "concat_certificate_key" do
  user "root"
  code <<-EOS
    cat #{node[:postfix][:courier][:ssl][:cert_path]}/certs/#{node[:postfix][:courier][:ssl][:cert_file]} #{node[:postfix][:courier][:ssl][:cert_path]}/private/#{node[:postfix][:courier][:ssl][:key_file]} > #{ssl_certificate}
    chmod "0400" #{ssl_certificate}
  EOS
  notifies :restart, "service[courier-imap-ssl]"
  notifies :restart, "service[courier-pop-ssl]"
end

template "/etc/courier/authdaemonrc" do
  source "courier/authdaemonrc.erb"
  owner "daemon"
  group "daemon"
  mode "0660"
  notifies :restart, "service[courier-authdaemon]"
end

template "/etc/courier/authldaprc" do
  source "courier/authldaprc.erb"
  owner "daemon"
  group "daemon"
  mode "0660"
  variables(
    :ldap_auth => ldap_auth
  )
  notifies :restart, "service[courier-authdaemon]"
end

template "/etc/courier/imapd" do
  source "courier/imapd.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[courier-imap]"
end

template "/etc/courier/imapd-ssl" do
  source "courier/imapd-ssl.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :certificate => ssl_certificate
  )
  notifies :restart, "service[courier-imap-ssl]"
end

template "/etc/courier/pop3d" do
  source "courier/pop3d.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[courier-pop]"
end

template "/etc/courier/pop3d-ssl" do
  source "courier/pop3d-ssl.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :certificate => ssl_certificate
  )
  notifies :restart, "service[courier-pop-ssl]"
end

cookbook_file "/etc/courier/maildroprc" do
  source "/etc/courier/maildroprc"
  owner "root"
  group "root"
  mode "0644"
end

cookbook_file "/etc/courier/quotawarnmsg" do
  source "/etc/courier/quotawarnmsg"
  owner "root"
  group "root"
  mode "0644"
end

cookbook_file "/usr/local/bin/maildrop-wrapper" do
  source "/usr/local/bin/maildrop-wrapper"
  owner "root"
  group "root"
  mode "0755"
end
