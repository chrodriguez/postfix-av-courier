certificate_manage node[:postfix][:ssl_databag_item] do
  cert_path node[:postfix][:ssl_cert_path]
  cert_file node[:postfix][:ssl_cert_file]
  key_file node[:postfix][:ssl_key_file]
  chain_file node[:postfix][:ssl_chain_file]
end
