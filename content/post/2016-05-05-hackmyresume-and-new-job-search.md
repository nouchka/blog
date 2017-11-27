---
title: HackMyResume and new job search
author: Jah
type: post
date: 2016-05-05T14:40:55+00:00
url: /2016/05/05/hackmyresume-and-new-job-search/
categories:
  - Tech

---
New year, new challenge, I will quit my current company in september.

As I&#8217;m looking for a new job, I worked on my resume again and I found http://please.hackmyresume.com/ website.
  
The idea behind is to use a json file for the data using https://github.com/jsonresume/resume-schema json format.
  
Then you use hackmyresume to apply theme for web or for files (ex PDF), using node packages.

It creates that kind of result <http://japromis.katagena.com/> based on a simple json file <https://raw.githubusercontent.com/nouchka/docker-hackmyresume/master/resume.json>

To manage my live version of this page, I create to docker image to create container for live CV:
  
<https://hub.docker.com/r/nouchka/hackmyresume/> which contains basic node env to generate file
  
<https://hub.docker.com/r/nouchka/hackmyresume-web/> which extends the first image and add a ngynx server.

Files are available on my github <https://github.com/nouchka>