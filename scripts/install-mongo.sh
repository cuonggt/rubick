#!/usr/bin/env bash

if [ -f /home/vagrant/.mongo ]
then
    echo "MongoDB already installed."
    exit 0
fi

touch /home/vagrant/.mongo

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927

echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list

sudo apt-get update
sudo apt-get install -y --allow-unauthenticated  mongodb-org

sudo sed -i -e 's/-C -n -q/-C -q/g' `which pecl`

sudo apt-get install -y autoconf g++ make openssl libssl-dev libcurl4-openssl-dev
sudo apt-get install -y libcurl4-openssl-dev pkg-config
sudo apt-get install -y libsasl2-dev

sudo pecl install mongodb

cat > /etc/systemd/system/mongodb.service <<EOL
[Unit]
Description=High-performance, schema-free document-oriented database
After=network.target
[Service]
User=mongodb
ExecStart=/usr/bin/mongod --quiet --config /etc/mongod.conf
[Install]
WantedBy=multi-user.target
EOL

sudo systemctl start mongodb
sudo systemctl status mongodb
sudo systemctl enable mongodb
sudo ufw allow 27017
sudo sed -i "s/bindIp: .*/bindIp: 0.0.0.0/" /etc/mongod.conf

sudo service nginx restart
