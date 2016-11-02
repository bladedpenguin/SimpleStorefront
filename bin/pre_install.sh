echo "Provisioning virtual machine..."
echo "Updating aptitude"

#Sometimes ubuntu wakes up already updating. We need to wait for that to finish.
while fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
    echo "Waiting for dpkg lock..." 
    sleep 5
done
#If dpkg stays locked forever, the deployment is bust anyway, so theres no point in breaking the loop. ASG lifecyccle stuff will eventually trash the instance.

apt-get update -y

echo "Installing Git"
apt-get install git -y 

echo "Installing Apache"
apt-get install apache2 -y

echo "Installing Java"
apt-get install -y default-jre

echo "Installing Redis"
apt-get -y install redis-server
chmod -R aou+rw /etc/redis
chmod -R aou+rw /var/log/redis

echo "Installing PHP7"
add-apt-repository -y ppa:ondrej/php
apt-get update
apt-get install -y php7.0
apt-get install -y php7.0-mcrypt
apt-get install -y php7.0-gd
apt-get install -y libapache2-mod-php7.0
apt-get install -y php7.0-curl
apt-get install -y php7.0-common
apt-get install -y php7.0-cli
apt-get install -y php7.0-mysql
apt-get install -y php7.0-mysqlnd
apt-get install -y php7.0-readline
apt-get install -y php-redis
apt-get install -y php7.0-xml
apt-get install -y php7.0-zip

echo "Installing Composer"
#curl -sS https://getcomposer.org/installer | /usr/bin/php -- --install-dir=/usr/bin --filename=composer
apt-get install -y composer

echo "Installing node and npm"
apt-get install -y npm nodejs-legacy
ln -s /usr/bin/nodejs /usr/bin/node

echo "Installing bower"
apt-get install nodejs-legacy npm
npm install -g bower

echo "Installing PHPUnit"
wget https://phar.phpunit.de/phpunit.phar
chmod +x phpunit.phar
mv phpunit.phar /usr/local/bin/phpunit

