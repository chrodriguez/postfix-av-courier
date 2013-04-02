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
  amavisd-new).each do |p|
    package p
  end

service "amavis" 

template "/etc/amavis/conf.d/50-user" do
  source "amavis/conf.d/50-user.erb"
  notifies :restart, "service[amavis]"
end


