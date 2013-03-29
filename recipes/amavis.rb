#
# Cookbook Name:: amavis
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#
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
  amavisd-new).each do |p|
    package p
  end


