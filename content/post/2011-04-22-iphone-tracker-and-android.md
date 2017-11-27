---
title: IPhone Tracker and Android
author: Jah
type: post
date: 2011-04-22T08:29:17+00:00
url: /2011/04/22/iphone-tracker-and-android/
categories:
  - Tech

---
Cette semaine a été marquée par la révélation sur le fichier consolidated.db présent sur les IPhones contenant les localisations du téléphone.

Pour ceux intéréssés par visualiser leurs données, la page <http://www.courbis.fr/Localisation-iPhone-votre.html> détaille bien la structure de la table sqlite en question et parser le fichier est assez simple avec un petit script en php.

Dans la foulée de cette révélation, des articles ont rapidement indiqué qu&#8217;Android faisait de même et des projets permettent également de parcourir ces informations (<https://github.com/packetlss/android-locdump> par exemple).

Or sur le fond, l&#8217;affaire est complétement différente: tous les téléphones ont votre position (ainsi que vos opérateurs via les antennes) car ce sont des informations nécessaires pour qu&#8217;ils puissent communiquer avec le réseau qu&#8217;il soit mobile ou wifi. Le problème soulevé par cette affaire est qu&#8217;Apple se sert de ces informations pour faire du datamining, stockant et conservant ces informations sur des longues durées (dans mon cas, 10mois). Android agit de manière complétement différente, stockant ces informations de manière limitée (cf MAX\_CELL\_REFRESH\_RECORD\_AGE) et jusqu&#8217;à preuve du contraire juste dans le but de faire du cache, c&#8217;est à dire d&#8217;éviter de rechercher une nouvelle fois l&#8217;information alors qu&#8217;on l&#8217;avait récupérer déjà y a peu de temps. On peut comparer cela au cache d&#8217;un navigateur et personne ne s&#8217;insurge que ces derniers stocke les données des sites que vous visitez.

Donc niveau communication, sortir &#8220;de toutes manières, Android fait pareil&#8221; est interessant comme ligne de défense mais sur le fond le problème reste limitée à Apple qui a choisit cette politique de datamining de manière consciente et sans en informer les consommateurs.