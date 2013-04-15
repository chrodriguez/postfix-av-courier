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

template "/etc/courier/authdaemonrc" do
  source "courier/authdaemonrc.erb"
  owner "daemon"
  group "daemon"
  mode "0660"
  notifies :restart, "service[courier-authdaemon]"
end
