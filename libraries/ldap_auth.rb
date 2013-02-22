def ldap_auth 
  data_bag_item(node.postfix.ldap.auth_databag, node.postfix.ldap.auth_databag_item)
end
def ssl_databag
  data_bag(node.postfix.ssl_databag)
end

def ldap_host
  if node.postfix.ldap.host.is_a?(String)
    [ node.postfix.ldap.host ]
  else
    node.postfix.ldap.host
  end
end

