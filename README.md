# Postfix cookbook
Postfix server with LDAP integration: SASL with PAM and ldap support, SSL, postgrey, policyd and more. Please see code to understand, improve and contribute.
This cookbook was designed to be used only with ubuntu 12.04. Contribution will be welcome

## Requirements
No explicit requirements are needed, but apt cookbook is usefull to keep packages up to date.

## Usage
Include default recipt to install postfix server. Please read attributes section to understand which one suites best for your environment

## Attributes
See `attributes/default.rb` to understand 

## Recipes
* default: install postfix
* sasl: enables sasl authentication. It will be called by default recipe if proper attributes are set


## TODO

**Implement:*a*
* SSL support
* Policyd recipe
* Encrypted databags

## Author
**Author:** Christian A. Rodriguez (<chrodriguez@gmail.com>)
