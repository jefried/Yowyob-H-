# Application Yowyob H!

application mobile de messagerie instantannée

## Getting Started

- Version SDK flutter utilisé pour le développement: 1.22.3
- Les dépendances du projet sont dans le fichier pubspec.yaml
- Pour récupérer les dépendance du projet tapez la commande:  flutter pub get
- Faites un "Run" du projet pour lancer l'application.

## Description des Dépendances du projet

- emoji_picker : gestion des émojis
- camera : intéraction avec la camera
- video_player : lecture des vidéos
- image_picker : gestion des images
- cached_network_image : sauvegarde des images dans le cache de l'application
- sqflite : gestion de base de données sqlite du téléphone
- contact_service : interaction avec le gestionnaire de contact du téléphone
- flutter_local_notifications : gestion des push-notifications
- flutter_sms : interaction avec l'application sms
- flutter_otp : gestion de l'authentification OTP
- photo_manager : Interaction avec la gallerie d'image/vidéos du téléphone

## Structure des fichiers du projet

- Le répertoire "lib/CustomUI" et "lib/my_Widgets" comporte les composants du projet
- Le répertoire "lib/Pages", "lib/Screens" et "lib/NewScreen" comporte toutes les pages du projet
- Le répertoire "lib/database" comporte les fichiers de gestion de la base de données du téléphone
- Le répertoire "lib/Model" comporte les fichiers définissant le Modèle de l'application
- Le répertoire "lib/utils" comporte les fichiers utiles tels que:
    - DateHelper.dart: pour le formatage de date
    - FileStoragePhone.dart: pour la gestion du stockage locale au niveau du téléphone
    - global_variable.dart: pour les variables globales du projet
    - LocalNotification.dart: pour les push-notifications du projet
    - network_util.dart: les fonctions de communication du module http/websocket

## Ressources du projet
