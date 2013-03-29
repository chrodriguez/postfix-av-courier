def ldap_auth 
  if node.postfix.ldap.auth_databag_encrypted
    Chef::EncryptedDataBagItem.load(node.postfix.ldap.auth_databag, node.postfix.ldap.auth_databag_item).to_hash
  else
    data_bag_item(node.postfix.ldap.auth_databag, node.postfix.ldap.auth_databag_item)
  end
end

def ssl_databag
  if node.postfix.ssl.enabled
    Chef::EncryptedDataBagItem.load(node.postfix.ssl.databag, node.postfix.ssl.databag_item).to_hash 
  else
    {}
  end
end

def ldap_host
  if node.postfix.ldap.host.is_a?(String)
    [ node.postfix.ldap.host ]
  else
    node.postfix.ldap.host
  end
end

