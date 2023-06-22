#!/bin/bash 
 
echo "Installation des mises à jours et des dépendences..." 
 
apt update -y && apt full-upgrade -y && apt-get install -y apache2 mariadb-server 
 
apt-get install -y php php-mysql php-ldap php-cli php-soap php-json graphviz php-xml php-gd php-zip libapache2-mod-php php-mbstring unzip 
 
echo "Installation terminé !"
echo "Création de la base de donnée et de l'utilisateur..."

mysql -u root <<EOF
CREATE DATABASE itop;
CREATE USER 'itop'@'localhost' IDENTIFIED BY 'operations';
GRANT ALL PRIVILEGES ON itop.* TO 'itop'@'localhost';
FLUSH PRIVILEGES;
EOF

echo "Création de la base de donnée et de l'utilisateur terminé !"
echo "Téléchargement de itop et installation..."

wget https://sourceforge.net/projects/itop/files/latest/download

mv download iTop-3.0.3-10998.zip

mkdir /var/www/itop

unzip iTop-3.0.3-10998.zip -d /var/www/itop/

#mv iTop-3.0.3-10998/* /var/www/itop/

echo "Modification des dossiers du serveur web..."

rm -r /var/www/html

chown -R www-data:www-data /var/www/itop/
chmod -R 744 /var/www/itop/

echo "Démarrage du serveur..."

service apache2 start
