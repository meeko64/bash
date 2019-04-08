#!/bin/bash

##
# création des Vhost Apache spécifique Symfony 3
# Usage:
# ./addVhost vhost_name [use_ssl]
##

# Définit le dossier racine des appli Apache
ROOT_DIR="/root/www/"

if [ $# == 0 ]
then 
	echo "To few arguments to process. Operation failed"
	exit -1
else
	# Copier le fichier templace-symfony vers /etc/apache2/sites-available
	# avec le nom vhost_name.conf
	cp ./templace-symfony /etc/apache2/sites-available/$1.conf

	# Créer le dossier dans le dossier /root/www
	mkdir -p $ROOT_DIR$1 $ROOT_DIR$1/web

	#Remplacer "templace" par "vhost_name" dans le fichier de config
	sed -i 's/templace/'$1'/g' /etc/apache2/sites-available/$1.conf

	# Ajouter le fichier de configuration à la liste des sites actifs
	a2ensite $1.conf

	# Mettre à jour le fichier hosts
	echo "10.31.1.78 $1.wrk www.$1.wrk" >> /etc/hosts

	# Vérifier l'execution globale
	touch $ROOT_DIR$1/web/app.php
	echo "<?php phpinfo();" >> $ROOT_DIR$1/web/app.php

	# Relancer Apache
	systemctl reload apache2.service
fi
