#!/bin/bash
 
# Affiche un message pour indiquer le début de l'installation
echo "Installation des mises à jours et des dépendences..." 
sleep 3

# Met à jour le système avec apt, et installe les paquets apache2 et mariadb-server
echo "On met à jour le système avec apt et on installe les paquets apache2 et mariadb-server"
sleep 3
apt update -y && apt full-upgrade -y
apt-get install -y apache2 mariadb-server 
clear

# Installe divers paquets PHP et d'autres dépendances nécessaires à iTop
echo "On Installe divers paquets PHP et d'autres dépendances nécessaires à iTop"
sleep 3
apt-get install -y php php-mysql php-ldap php-cli php-soap php-json php-curl graphviz php-xml php-gd php-zip libapache2-mod-php php-mbstring unzip 
clear

# Affiche un message pour indiquer que la création de la base de données et de l'utilisateur va commencer
echo "Création de la base de donnée et de l'utilisateur..."
sleep 3
# Crée une nouvelle base de données et un nouvel utilisateur dans MariaDB
mysql -u root <<EOF
CREATE DATABASE iTop;
CREATE USER 'iTop'@'localhost' IDENTIFIED BY 'operations';
GRANT ALL PRIVILEGES ON itop.* TO 'itop'@'localhost';
FLUSH PRIVILEGES;
EOF

# Affiche un message pour indiquer que la création de la base de données et de l'utilisateur est terminée
echo "Création de la base de donnée et de l'utilisateur terminé !"
sleep 2
# Affiche un message pour indiquer que le téléchargement et l'installation de iTop vont commencer
echo "Téléchargement de iTop et installation...Please wait !"
sleep 5
# Télécharge la dernière version de iTop depuis SourceForge
wget https://sourceforge.net/projects/itop/files/latest/download

# Renomme le fichier téléchargé en iTop-3.0.3-10998.zip
mv download iTop-3.0.3-10998.zip

# Crée un nouveau dossier pour iTop dans le dossier du serveur web
mkdir /var/www/html/itop

# Décompresse l'archive iTop dans le dossier du serveur web
unzip iTop-3.0.3-10998.zip -d /var/www/html/itop/
clear

# Affiche un message pour indiquer que les dossiers du serveur web vont être modifiés
echo "Modification des dossiers du serveur web..."
sleep 3
# Change le propriétaire des fichiers iTop à www-data (l'utilisateur par défaut du serveur web Apache sur Debian)
chown -R www-data:www-data /var/www/html/itop/

# Change les permissions des fichiers iTop pour que le propriétaire puisse lire, écrire et exécuter les fichiers
chmod -R 744 /var/www/html/itop/

# Affiche un message pour indiquer que le serveur va démarrer
echo "Démarrage du serveur apache..."
sleep 2
# Démarre le service Apache
service apache2 start
systemctl enable apache2
# Affiche un message pour indiquer que le serveur à démarre

echo "Le serveur apache a été démarré !"
# Affiche un message pour indiquer que l'installation est terminée
echo "Installation de iTop terminé !"
echo .
echo ..
echo "Note : Pour accéder à l'interface web, vous devez saisir ceci : http://@ip_serveur/itop/web"
