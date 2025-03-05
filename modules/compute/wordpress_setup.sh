#!/bin/bash

# Update package lists
apt-get update

# Install Apache
apt-get install -y apache2

# Install MySQL and set root password
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root_password'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root_password'
apt-get install -y mysql-server

# Install PHP and required extensions
apt-get install -y php libapache2-mod-php php-mysql php-xml php-mbstring

# Restart Apache to load PHP module
systemctl restart apache2

# Create WordPress database and user
mysql -u root -proot_password <<EOF
CREATE DATABASE wordpress;
CREATE USER 'wordpressuser'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'localhost';
FLUSH PRIVILEGES;
EOF

# Download and extract WordPress
wget -P /tmp https://wordpress.org/latest.tar.gz
tar -xzf /tmp/latest.tar.gz -C /tmp
mv /tmp/wordpress/* /var/www/html/

# Set permissions
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Configure Apache
cat <<EOT > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
    ServerAdmin admin@example.com
    DocumentRoot /var/www/html
    ServerName example.com
    ServerAlias www.example.com
    <Directory /var/www/html>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOT

# Enable site and rewrite module
a2enmod rewrite
systemctl reload apache2

# Configure WordPress
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sed -i "s/database_name_here/wordpress/" /var/www/html/wp-config.php
sed -i "s/username_here/wordpressuser/" /var/www/html/wp-config.php
sed -i "s/password_here/password/" /var/www/html/wp-config.php

# Generate WordPress salts
SALT=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)
printf '%s\n' "g/\(define('AUTH_KEY',\).*/d
g/\(define('SECURE_AUTH_KEY',\).*/d
g/\(define('LOGGED_IN_KEY',\).*/d
g/\(define('NONCE_KEY',\).*/d
g/\(define('AUTH_SALT',\).*/d
g/\(define('SECURE_AUTH_SALT',\).*/d
g/\(define('LOGGED_IN_SALT',\).*/d
g/\(define('NONCE_SALT',\).*/d
wq" | ed -s /var/www/html/wp-config.php
printf '%s\n' "1i
$SALT
.
wq" | ed -s /var/www/html/wp-config.php

# Restart Apache
systemctl restart apache2
