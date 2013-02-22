#
# Cookbook Name:: postfix
# Recipe:: default
#
# Copyright (C) 2012 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

# Databag items
# Needed packages
package "postfix"
package "postfix-ldap"

# Mail name
file "/etc/mailname" do
  content node.postfix.myorigin
  notifies :restart, "service[postfix]"
end

# Aliases file
template "/etc/aliases" do
  source "aliases.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :run, "execute[aliases]"
end

# Some basic checks
%w(
    /etc/postfix/tables/client_access
    /etc/postfix/tables/sender_access
    /etc/postfix/tables/bogus_mx
    /etc/postfix/tables/recipient_access
).each do | element |
  postfix_cookbook_file element do
    postmap true
  end
end

# Virtual mailbox LDAP
virtual_mailbox_ldap = node.postfix.virtual_mailbox_maps.ldap.config
directory File.dirname(virtual_mailbox_ldap)  do
  recursive true
  mode "0755"
  owner "root"
  group "root"
end

template virtual_mailbox_ldap do
  source "ldap/virtual_mailbox.erb"
  owner "root"
  group "root"
  mode "0400"
  variables(
    :ldap_auth => ldap_auth,
    :ldap_host => ldap_host,
    :ldap_base => node.postfix.virtual_mailbox_maps.ldap.search_base,
    :ldap_query => node.postfix.virtual_mailbox_maps.ldap.query_filter,
    :result_format => node.postfix.virtual_mailbox_maps.ldap.result_format,
    :result_attribute => node.postfix.virtual_mailbox_maps.ldap.result_attribute
  )
  notifies :restart, "service[postfix]"
end

# Build virtual_mailbox_maps
virtual_mailbox_maps = node.postfix.virtual_mailbox_maps.collect {|x,y| "#{x}:#{y[:config]}"}

#
# Virtual alias maps
virtual_alias_ldap = node.postfix.virtual_alias_maps.ldap.config
directory File.dirname(virtual_alias_ldap)  do
  recursive true
  mode "0755"
  owner "root"
  group "root"
  notifies :restart, "service[postfix]"
end


template virtual_alias_ldap do
  source "ldap/virtual_alias.erb"
  owner "root"
  group "root"
  mode "0400"
  variables(
    :ldap_auth => ldap_auth,
    :ldap_host => ldap_host,
    :ldap_base => node.postfix.virtual_alias_maps.ldap.search_base,
    :ldap_query => node.postfix.virtual_alias_maps.ldap.query_filter,
    :special_result_filter => node.postfix.virtual_alias_maps.ldap.special_result_filter,
    :result_attribute => node.postfix.virtual_alias_maps.ldap.result_attribute
  )
  notifies :restart, "service[postfix]"
end

virtual_alias_hash = node[:postfix][:virtual_alias_maps][:hash][:config]


template virtual_alias_hash do
  source "virtual_alias_hash.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :virtual_aliases => node[:postfix][:virtual_alias_maps][:hash][:alias_values]
  )
  notifies :restart, "service[postfix]"
  notifies :run, "postfix_postmap_hash[#{virtual_alias_hash}]"
end

postfix_postmap_hash virtual_alias_hash


# Build virtual_alias_maps
virtual_alias_maps = node.postfix.virtual_alias_maps.collect {|x,y| "#{x}:#{y[:config]} "}

# Use SSL / TLS
include_recipe "postfix::ssl" unless ssl_databag.empty?


# Use policyd service
include_recipe "postfix::policyd" if node.postfix.policyd

# Use SPF service
package "postfix-policyd-spf-perl" if node.postfix.policyspf 

# Use postgrey service
package "postgrey" if node.postfix.policypostgrey

# Postfix master configuration
template "/etc/postfix/master.cf" do
  source "master.cf.erb"
  owner "root"
  group "root"
  mode "0644"
end

# Postfix main configuration
virtual_mailbox_maps
template "/etc/postfix/main.cf" do
  source "main.cf.erb"
  owner "root"
  group "root"
  variables(
    :virtual_mailbox_maps => virtual_mailbox_maps,
    :virtual_alias_maps => virtual_alias_maps
  )
  mode "0644"
end

service "postfix" do
  action [ :enable, :restart ]
  subscribes :restart, resources(
    :template => "/etc/postfix/main.cf",
    :template => "/etc/postfix/master.cf")
end

execute "aliases" do
  action :nothing
  command "newaliases"
  user "root"
end

# Use SASL authentication
include_recipe "postfix::sasl" if node[:postfix][:sasl]
