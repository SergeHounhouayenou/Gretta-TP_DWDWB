####### HEADER #######

tâche : Installer Drupal dans un conteneur Docker sur une VM Ubuntu
objectifs poursuivis :

Installer Drupal de manière efficace et fiable dans un environnement Docker pour une gestion facile des dépendances.
Assurer la bonne connexion de Drupal à une base de données MariaDB.
Finaliser l'accès via une interface web pour la configuration et l'administration de Drupal.
Automatiser autant que possible les processus afin de réduire la gestion manuelle.
segments de la tâche :

Préparation de l'environnement Docker
Installation des images Docker de Drupal et MariaDB
Configuration de la connexion entre Drupal et la base de données MariaDB
Configuration de l'interface utilisateur pour l'administration via la page de setup de Drupal
Vérification de la persistance des données et gestion des permissions
Évaluation des problèmes de sécurité et ajustements nécessaires
####### BODY #######

SECTION 1
nom : Préparation de l'environnement Docker
description : Préparer et configurer Docker sur une VM Ubuntu pour héberger Drupal et sa base de données MariaDB.
commandes utilisées :

sudo apt update
sudo apt install docker.io
sudo systemctl enable docker
problèmes rencontrés :
Docker n'était pas correctement installé sur la machine.
solutions apportées :
Installation de Docker en utilisant les commandes classiques sur Ubuntu, puis démarrage et activation du service Docker pour un démarrage automatique.
SECTION 2
nom : Installation des images Docker de Drupal et MariaDB
description : Téléchargement et configuration des images Docker de Drupal et MariaDB.
commandes utilisées :

docker pull drupal:11-apache
docker pull mariadb:latest
Sous-problèmes rencontrés :
Les conteneurs MariaDB et Drupal ont été créés mais il a fallu résoudre des conflits de versions pour s'assurer que MariaDB était correctement configuré.
Réponses apportées :
Résolution des conflits en choisissant explicitement les versions appropriées pour les conteneurs et ajustement des variables d'environnement dans le fichier .yml.
SECTION 3
nom : Configuration de la connexion entre Drupal et la base de données MariaDB
description : Configurer la connexion entre le conteneur Drupal et MariaDB pour assurer que Drupal puisse accéder à la base de données.
commandes utilisées :

Modification du fichier settings.php pour ajuster les paramètres de connexion à la base de données.
problèmes rencontrés :
Les identifiants du fichier .yml n'étaient pas correctement reconnus par Drupal, entraînant des erreurs de connexion.
solutions apportées :
Modification manuelle des paramètres dans Drupal pour utiliser un mot de passe valide et une connexion correcte à la base de données MariaDB.
SECTION 4
nom : Configuration de l'interface utilisateur pour l'administration via la page de setup de Drupal
description : Lancer l'interface graphique de Drupal pour configurer le site via le navigateur web.
commandes utilisées :

Accès via le navigateur à http://localhost:8080
problèmes rencontrés :
Lors du setup, Drupal ne reconnaissait pas les paramètres de connexion à la base de données.
solutions apportées :
Résolution du problème de connexion en ajustant manuellement les paramètres dans la configuration de Drupal après avoir changé le mot de passe pour la base de données.




Articles
nom : Base de données et paramètres de connexion
description : Configuration et gestion des paramètres de base de données.
commandes utilisées :

Accès à MariaDB via la commande mariadb -u drupal -pdrupal drupal pour valider les paramètres.
sujet informatique rencontrés :
Configuration des paramètres de connexion via Docker et résolution des problèmes de permissions entre Docker et la base de données MariaDB.
Objets fournis :
Fichier .yml pour la configuration des services dans Docker Compose.




PARAGRAPHES
nom : Docker et ses services
description : Docker permet de gérer les conteneurs d'application, mais nécessite des configurations spécifiques pour l'interaction avec la base de données et le bon fonctionnement des applications comme Drupal.
objets utilisés :

Docker Compose pour la gestion des services.
Conteneur Docker de Drupal et MariaDB.
culture de l'obsolète :
Les configurations manuelles des bases de données et des applications peuvent être remplacées par des outils d'automatisation comme Docker Compose pour améliorer la productivité.
actualité de la veille technologique :
L'utilisation des conteneurs Docker pour la gestion des applications comme Drupal est courante, mais des problèmes peuvent survenir lors de l'intégration de services comme MariaDB avec des configurations spécifiques.
Références scientifiques et citations :
Docker Docs - Documentation officielle pour comprendre les pratiques et configurations d'automatisation.
PHRASES
nom : Docker - Gestion des conteneurs
description : Chaque ligne de commande et chaque interaction avec Docker peut être vue comme une phrase dans le contexte d'un processus automatisé de configuration.
objets utilisés :

Docker Compose, fichier .yml, commandes Docker.
culture de l'obsolète :
L'automatisation des processus de déploiement devient incontournable dans un environnement de développement moderne.
actualité de la veille technologique :
L'usage de Docker pour la gestion d'applications comme Drupal devient de plus en plus standardisé.
Mots
nom : Base de données, Drupal, Docker
description : Ces mots-clés sont essentiels pour la compréhension de la configuration et de l'optimisation de l'environnement de développement.
objets utilisés :

Docker, Drupal, MariaDB.
culture de l'obsolète :
L'évolution vers des environnements de développement conteneurisés remplace progressivement les installations manuelles et les configurations longues.
LETTRES
nom : Dockerfile
description : Le Dockerfile permet de spécifier les étapes nécessaires pour construire un conteneur personnalisé.
objets utilisés :

Dockerfile.
culture de l'obsolète :
L'écriture manuelle des configurations pour chaque service devient une méthode obsolète au profit des outils d'automatisation.
Couleurs
nom : Code couleur pour les configurations
description : Définir un code couleur pour chaque composant de l'interface facilite la gestion visuelle et le suivi des modifications.
objets utilisés :

Interface web, configuration Docker.
fin de la synthèse.
