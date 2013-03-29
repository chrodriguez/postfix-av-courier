certificate_manage node[:postfix][:ssl][:databag_item] do
  cert_path node[:postfix][:ssl][:cert_path]
  cert_file node[:postfix][:ssl][:cert_file]
  key_file node[:postfix][:ssl][:key_file]
  chain_file node[:postfix][:ssl][:chain_file]
end
