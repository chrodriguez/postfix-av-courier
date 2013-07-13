#
# Cookbook Name:: spamassassin
# Recipe:: default
#
# Copyright (C) 2013 Leandro Di Tommaso
# 
# All rights reserved - Do Not Redistribute
#

%w(
  dspam
  spamassassin
  ).each do |p|
    package p
  end

service "spamassassin" 

template "/etc/spamassassin/local.cf" do
  source "spamassassin/local.erb"
  notifies :restart, "service[spamassassin]"
end

if node[:postfix][:spamassassin][:use_mysql]
	package "mysql-client"
end
