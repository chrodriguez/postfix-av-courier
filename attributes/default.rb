# User and group to run postfix as
default[:postfix][:user] = "postfix"
default[:postfix][:group] = "postfix"

# Aliases for mydestination
default[:postfix][:aliases] = {
  "mailer-daemon" => "root",
  "postmaster" => "root",
}

# ldap secrets databag
default[:postfix][:ldap][:auth_databag_encrypted] = true
default[:postfix][:ldap][:auth_databag] = "secrets"
default[:postfix][:ldap][:auth_databag_item] = "ldap_auth"

# SSL cetrtificates to configure SSL
default[:postfix][:ssl][:enabled] = false
default[:postfix][:ssl][:databag] = "certificate"
default[:postfix][:ssl][:databag_item] = nil
default[:postfix][:ssl][:cert_path] = "/etc/postfix/ssl"
default[:postfix][:ssl][:cert_file] = "cert.crt"
default[:postfix][:ssl][:key_file] = "cert.key"
default[:postfix][:ssl][:chain_file] = "chain.crt"

# ldap hosts
default[:postfix][:ldap][:host] = %w(ldap://server1.midominio ldap://server2.midominio.com)

# libpam ldap configuration
default[:postfix][:libpam][:smtp] = "/etc/pam.d/smtp"
default[:postfix][:libpam][:conf] = "/etc/ldap.conf"
default[:postfix][:libpam][:secret] = "/etc/ldap.secret"
default[:postfix][:libpam][:base] = "ou=users,o=organization"
default[:postfix][:libpam][:login_attribute] = "uid"

# Postfix configuration
default[:postfix][:myorigin] = 'midominio.com'
default[:postfix][:virtual_mailbox_domains] = %w(midominio.com miotrodominio.com)
default[:postfix][:virtual_mailbox_maps][:ldap][:config] = "/etc/postfix/ldap/ldap-mailboxes.cfg"
default[:postfix][:virtual_mailbox_maps][:ldap][:search_base] = "ou=users,o=organization"
default[:postfix][:virtual_mailbox_maps][:ldap][:query_filter] = "(&(&(uid=%u)(mail=%u@midominio.com))(!(nsaccountlock=true)))"
default[:postfix][:virtual_mailbox_maps][:ldap][:result_format] = "%d/%u/Maildir/",
default[:postfix][:virtual_mailbox_maps][:ldap][:result_attribute] = "mail"
default[:postfix][:virtual_alias_maps][:ldap][:config] = "/etc/postfix/ldap/ldap-alias.cfg"
default[:postfix][:virtual_alias_maps][:ldap][:search_base] = "ou=aliases,ou=mail,o=organization"
default[:postfix][:virtual_alias_maps][:ldap][:query_filter] = "(mail=%u@midominio.com)"
default[:postfix][:virtual_alias_maps][:ldap][:result_attribute] = "mail"
default[:postfix][:virtual_alias_maps][:ldap][:special_result_filter] = "%s@%d"
default[:postfix][:virtual_alias_maps][:hash][:config] = "/etc/postfix/admin_alias"
default[:postfix][:virtual_alias_maps][:hash][:alias_values] = {}
default[:postfix][:mydestination] = "localhost, localhost.localdomain"
default[:postfix][:myhostname] = "localhost"
default[:postfix][:relayhost] = nil
default[:postfix][:message_size_limit] = "15728640"
default[:postfix][:mynetworks] = "127.0.0.0/8"
default[:postfix][:virtual_transport] = "smtp:[amavis.otroserver.com]"

# SASL authentication options
default[:postfix][:sasl][:enabled] = false
default[:postfix][:sasl][:conf] = "/etc/postfix/sasl/smtpd.conf"
default[:postfix][:sasl][:group] = "sasl"
default[:postfix][:sasl][:auth_domain] = "midominio.com"

# Use policyd / SPF or Postgrey??
default[:postfix][:policyd] = "inet:127.0.0.1:10031"
default[:postfix][:policyspf] = nil
default[:postfix][:policypostgrey] = "inet:127.0.0.1:10023"

# is postfix run chrooted
default[:postfix][:chrooted] = true

# Amavis
#############################################
default[:postfix][:amavis][:enabled] = false
default[:postfix][:amavis][:host] = "127.0.0.1"
default[:postfix][:amavis][:feed] = "amavisfeed"
default[:postfix][:amavis][:port] = "10024"
default[:postfix][:amavis][:max_servers] = "10"
default[:postfix][:amavis][:syslog_priority] = "info"
default[:postfix][:amavis][:x_header_line] = "$myproduct_name at $mydomain"
default[:postfix][:amavis][:virus_admin] = "postmaster@example.domain"
# Enable antivirus?
default[:postfix][:amavis][:av][:enabled] = true
# Enable antispam?
default[:postfix][:amavis][:spam][:enabled] = true
default[:postfix][:amavis][:spam][:subject_tag] = "***SPAM***"
default[:postfix][:amavis][:spam][:tag_level] = "-999"
default[:postfix][:amavis][:spam][:tag2_level] = "6.31"
default[:postfix][:amavis][:spam][:kill_level] = "6.31"
default[:postfix][:amavis][:spam][:dsn_cutoff_level] = "10"
# Actions taken when:
default[:postfix][:amavis][:final_virus_destiny] = "D_DISCARD"
default[:postfix][:amavis][:final_banned_destiny] = "D_DISCARD"
default[:postfix][:amavis][:final_spam_destiny] = "D_DISCARD"
default[:postfix][:amavis][:final_bad_header_destiny] = "D_PASS"

# clamav
default["clamav"]["freshclam"]["enabled"] = true
default["clamav"]["clamd"]["enabled"] = true
