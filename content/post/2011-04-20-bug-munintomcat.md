---
title: Bug Munin+tomcat
author: Jah
type: post
date: 2011-04-20T22:27:48+00:00
excerpt: Bug munin des scripts pour tomcat
url: /2011/04/20/bug-munintomcat/
categories:
  - Tech

---
Munin permet de monitorer différents serveurs via des scripts (en perl ou autres). Parmi les scripts disponibles, 4 scripts permettent de monitorer un serveur tomcat.

Cependant les versions anciennes de ces scripts comportent un bug <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=543523>.

Le script  appelle l&#8217;url /manager/status?XML=true sur le serveur tomcat (équivalent du server-status apache) et parse les informations. Or la structure du fichier xml est différente de celle attendue par le script. Le problème se situe au niveau du tag connector, &#8216;http-$PORT&#8217; au lieu de &#8216;http$PORT&#8217;

En ajoutant le tiret dans les 3 scripts buggés (ou en récupérant les dernières versions), ces derniers fonctionnent.