---
title: Docker image support and optimization
author: Jah
type: post
date: 2019-12-15T19:04:23+00:00
categories:
  - Tech

---

I'm maintaining several docker image and recently I was facing some issues to upgrade one of this image.

I have built a docker symfony image which I use for my symfony project: https://github.com/nouchka/docker-symfony

Symfony just rolled out a major update with version 5 and PHP just released 7.4 so I wanted to give a try and upgrade my image.

# Support of features

As this image is downloaded from others, I try to keep in mind that I didn't want to remove features from old version.

My main issue for that was the fact I didn't really list theses features, I just added them when I needed them on one of my project.

It was quite anti-pattern to create a big common image for all my projects and that's why I think symfony don't provide 
a docker image because every project has its own requirements and should keep image size the smallest possible.

So I decided to wait for next major release and to remove some features to make it clean.
But the most important part, I will make the features list clean and defined and I will update the CI to be able to check them.

So for next update I will be able to play with different version and to know quickly if upgrade is valid

# Source image and build size

When I was upgrading PHP I had to think about the source image of my image. I was using debian image before but for PHP7.4 packages were not yet release on debian apt.

Official repository are the most trustworthy but the later updated because debian/ubuntu want stable package with quality. 
Another choice was a ppa repository, private repository but your image depends on a user you have to trust. 
Another option is the official PHP docker image, in two versions alpine or debian but you have to build yourself the extensions you need.

If you want the last upgrade fast: official image > private ppa > official repository. If you want security: official repository > official image > private ppa.

You also want to check the size of the image so I did a small test, creating PHP 7.3 image from 4 different sources: https://github.com/nouchka/test-docker-php-image

Results show that official debian package setup is the smallest, probably because of extension package well optimized. 
Official PHP docker image is the biggest because it contains dev tools to build extension. 
So for the smallest image: debian package smaller than ppa smaller than official image (alpine or debian).

At the end I decided to use official PHP image for a beta tag for the last version waiting the official release on debian repositories.
