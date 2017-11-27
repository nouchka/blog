---
title: Performances monitoring
author: Jah
type: post
date: 2014-03-21T11:39:10+00:00
url: /2014/03/21/performances-monitoring/
categories:
  - Tech

---
If you want to monitor a website you can setup easily a regular cron to check the performances.

You just need [PhantomJS][1] which is a headless browser. For a 64bits version:

    
    if ! which bzip2 >/dev/null; then
        apt-get install bzip2
    fi
    if ! [ -f "/usr/local/bin/phantomjs" ]; then
    	cd /tmp/
    	wget https://phantomjs.googlecode.com/files/phantomjs-1.9.2-linux-i686.tar.bz2
    	tar xvf phantomjs-1.9.2-linux-i686.tar.bz2
    	cp phantomjs-1.9.2-linux-i686/bin/phantomjs /usr/local/bin/
    	chmod +x /usr/local/bin/phantomjs
    fi
    

Then we will use [confess.js][2] script with PhantomJS. Download the confess.js.
  
Create a basic configuration file config.json:

    
    {
      "task": "appcache",
      "userAgent": "chrome",
      "userAgentAliases": {
        "iphone": "Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_0 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8A293 Safari/6531.22.7",
        "android": "Mozilla/5.0 (Linux; U; Android 2.2; en-us; Nexus One Build/FRF91) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1",
        "chrome": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.12 Safari/535.11"
      },
      "wait": 0,
      "consolePrefix": "#",
      "verbose": true,
      "appcache": {
        "urlsFromDocument": true,
        "urlsFromRequests": false,
        "cacheFilter": ".*",
        "networkFilter": null
      }
    }
    

Then you can launch phantomJS:

    /usr/local/bin/phantomjs confess.js http://www.google.com/ performance config.json

You can combine this to receive a mail alert when loading time rise above a limit:

    
    if ! which mail >/dev/null; then
        apt-get install mailutils
    fi
    
    /usr/local/bin/phantomjs confess.js http://www.google.com/ performance config.json > daily-report.txt
    
    TOTAL=`cat daily-report.txt|grep 'Elapsed load time:'|sed 's/Elapsed load time:[ ]*//g'|sed 's/ms//g'`
    if [ $TOTAL -gt 8000 ];then
    	mail -s "[ALERT][Monitoring] - Loading time $TOTAL ms" $MAIL < daily-report.txt
    fi
    
    rm daily-report.txt
    

Add all in a script, create a cron and you have a basic monitoring system.

 [1]: http://phantomjs.org/
 [2]: https://github.com/jamesgpearce/confess