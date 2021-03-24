#!/bin/bash
sudo apt-get update
sudo debconf-set-selections <<< "postfix postfix/mailname string coditas.com"
sudo debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
sudo apt-get install --assume-yes postfix
sudo echo "[smtp.gmail.com]:587 manish.agnani@coditas.com:****************" >> /etc/postfix/sasl/sasl_passwd 
sudo postmap /etc/postfix/sasl/sasl_passwd
sudo sed -i 's/relayhost =/relayhost = [smtp.gmail.com]:587/g' /etc/postfix/main.cf
sudo echo "# Enable SASL authentication
smtp_sasl_auth_enable = yes
smtp_sasl_security_options = noanonymous
smtp_sasl_password_maps = hash:/etc/postfix/sasl/sasl_passwd
smtp_tls_security_level = encrypt
smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt" >> /etc/postfix/main.cf
sudo systemctl restart postfix
