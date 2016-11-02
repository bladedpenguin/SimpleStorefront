

#echo "Installing mysql-server"
#apt-get install debconf-utils -y > /dev/null
#debconf-set-selections <<< 'mysql-server mysql-server/root_password password toor'
#debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password toor'
#apt-get install mysql-server-5.6 -y > /dev/null
#mysql -uroot -ptoor -e "create database simple_storefront"
#mysql -uroot -ptoor -e "SET PASSWORD = PASSWORD('');"

#get the configuration for the database
apt-get install -y awscli
aws s3 cp s3://noinctest/secret/parameters.yml /var/www/app/config/parameters.yml

sudo chown -R www-data /var/www
cd /var/www/
sudo -u www-data /usr/bin/composer update
sudo -u www-data /usr/bin/composer install

apache2ctl restart

echo "Enabling mod-rewrite"
a2enmod rewrite

echo "Enabling headers"
a2enmod headers

#echo "Creating vagrant/public_html"
#mkdir /home/vagrant/public_html
#mkdir /home/vagrant/public_html/web

echo "Creating index.html landing"
echo "<?php echo 'Hello World!';" > /var/www/web/index.php

#chown -R vagrant.vagrant /home/vagrant/public_html

echo "Configuring Apache"
#perl -p -i -e 's/www-data/vagrant/ge;' /etc/apache2/envvars

cat <<EOF > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
        DocumentRoot /var/www/web

        <Directory /var/www/web>
                # enable the .htaccess rewrites
                AllowOverride All
                Require all granted
        </Directory>

        ServerAdmin webmaster@localhost

</VirtualHost>
EOF

echo "Restarting Apache2"
service apache2 restart

echo "Adding Helper Aliases"
echo "source ~/SimpleStorefront/.bash_aliases" >> .bashrc
