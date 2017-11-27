---
title: Debian package md5sum
author: Jah
type: post
date: 2014-03-04T10:33:08+00:00
excerpt: Restart service in debian package only if necessary
url: /2014/03/04/debian-package-md5sum/
categories:
  - Tech

---
If you manage a debian package, you sometimes need to restart a service after the setup. It&#8217;s generally done in the postinst script. But sometimes you didn&#8217;t have change configuration files and you don&#8217;t want to restart the service.

Here a simple example where postinst script will check if configuration files have changed and restart service only when necessary.

In this example, my package contains virtual hosts for apache server. I will make a md5sum of the files before the setup of my new version of the package.

In the DEBIAN/preinst:

    find /etc/apache2/sites-available/ -type f -print0 | xargs -0 md5sum >> /tmp/apache-confs.old

And then I will check for changes files in the DEBIAN/postinst:

    find /etc/apache2/sites-available/ -type f -print0 | xargs -0 md5sum >> /tmp/apache-confs.new

    DIFF=$(diff /tmp/apache-confs.new /tmp/apache-confs.old)
    if [ "$DIFF" != "" ]; then
    service apache restart
    fi
    rm /tmp/apache-confs.*

Warning: diff exit status code is 1 when there are differences between file so &#8220;set -e&#8221; will break the postinst script if you have one.