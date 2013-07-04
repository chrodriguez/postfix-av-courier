#
# Cookbook Name:: amavis
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#
include_recipe "clamav"

%w(
  binutils
  file
  gzip
  bzip2
  lzop
  rpm2cpio
  cabextract
  ncompress
  gzip
  freeze
  melt
  nomarch
  arc
  arj
  rar
  unrar
  zoo
  lha
  pax
  cpio
  ripole
  dspam
  spamassassin
  sshfs
  amavisd-new).each do |p|
    package p
  end

service "amavis" 

template "/etc/amavis/conf.d/50-user" do
  source "amavis/conf.d/50-user.erb"
  notifies :restart, "service[amavis]"
end

group node[:postfix][:amavis][:group] do
  members node[:clamav][:user]
  append true
  action :modify
  notifies :restart, "service[amavis]"
  notifies :restart, "service[#{node["clamav"]["clamd"]["service"]}]"
end

# Spamassassin training template
template "/usr/local/bin/sa-train" do
  source "amavis/sa-train.erb"
  mode "0755"
  owner "root"
  variables(
    :mailboxes_base => node[:postfix][:sa_train][:mailboxes_base],
    :spam_learn_imap_folder => node[:postfix][:sa_train][:spam_imap_folder],
    :jam_learn_imap_folder => node[:postfix][:sa_train][:jam_imap_folder],
    :remote_fs => node[:postfix][:sa_train][:remote_fs][:enabled],
    :remote_fs_user => node[:postfix][:sa_train][:remote_fs][:user],
    :remote_fs_host => node[:postfix][:sa_train][:remote_fs][:host],
    :remote_fs_path => node[:postfix][:sa_train][:remote_fs][:path]
  )
end

if node[:postfix][:sa_train][:enabled] then
  cron "sa_train" do
    minute "0" 
    command "/usr/local/bin/sa-train"
    action :create
  end 
else
  cron "sa_train" do
    minute "0" 
    command "/usr/local/bin/sa-train"
    action :delete
  end 
end
