---
title: Docker multiple tags with one branch
author: Jah
type: post
date: 2017-11-29T19:04:23+00:00
categories:
  - Tech

---
If you manage multiple docker images on docker hub, you want to make the support the easiest possible.
But most of the time you start creating tags because your application follow the version of another application or you just want to try using the new debian image.

To create tag, docker hub provides you the Build settings page where you can declare tags, giving you 2 options:
* use branch (Docker hub does it automatically, but you can do more specific stuff with it)
* use different Dockerfile files
Both are not perfect because branches need to be merge and multiple dockerfile results in duplicate code most of the time.

If yours tags are quite similar (base image or one RUN different) you have a better option using build args.
Build arg are like environment variables but used during the build. You can specify them with docker build --build-arg <varname>=<value> or in docker cloud at a global scope ([Docker Cloud Automated Build][1]).
They can be use in most of the directives present in Dockerfile; for example you can change the base image, change RUN instruction using if/else

But how to use it with tag: start to rewrite yours dockerfiles according to differences between tags adding build args.

	ARG  BASE_IMAGE=stable
	FROM debian:${BASE_IMAGE}

	ARG PHPVERSION=5
	ARG PHPCONF=/etc/php/5

	RUN echo $PHPVERSION $PHPCONF && \
		cat /etc/debian_version && \
		[ "$PHPVERSION" != "5" ] || echo "specific for version 5" && \
		echo "global setup"

There are 3 builds args defining my docker image and if I want to build different tags I just have to pick the right build parameters.

But on Docker Hub you don't have this feature, so you can use the [phase hooks][2].
Hooks are script executed at specific moment during the build (pre push for example) and one of the hook is call build and replace the standard build command used. It allows you to write your own logic, define all the build arguments you want. (You will always need to create tags in Docker hub)

	#!/usr/bin/env bash
	
	LATEST_VERSION="5"
	
	if [ "$DOCKER_TAG" = "$LATEST_VERSION" ]; then
		DOCKER_TAG=latest
	fi
	
	if [ "$DOCKER_TAG" = "latest" ]; then
		docker build -t ${IMAGE_NAME} .
	else
		if [ -f "Dockerfile.${DOCKER_TAG}" ]; then
			docker build -t ${IMAGE_NAME} -f Dockerfile.${DOCKER_TAG} .
		else
			if [ "$DOCKER_TAG" = "6" ]; then
				docker build -t ${IMAGE_NAME} \
					--build-arg=BASE_IMAGE=stretch \
					--build-arg=PHPVERSION=7 \
					--build-arg=PHPCONF=/etc/php/7.0 \
					.
			fi
		fi
	fi

In this hooks/build file, $DOCKER_TAG is setup with values of the Build settings page. The latest tag is define here as the version 5. Some tags use specific Dockerfile files. Version 6 use the same Dockerfile than version 5, but with a stretch base image and others different build arguments. You can do what you want, it's a bash script (do not build more than one, it will not work).

At the end, my Build Settings doesn't specify branches or different dockerfile but I have at the end 4 different tags.

<blockquote class="instagram-media" data-instgrm-captioned data-instgrm-version="7" style=" background:#FFF; border:0; border-radius:3px; box-shadow:0 0 1px 0 rgba(0,0,0,0.5),0 1px 10px 0 rgba(0,0,0,0.15); margin: 1px; max-width:658px; padding:0; width:99.375%; width:-webkit-calc(100% - 2px); width:calc(100% - 2px);"><div style="padding:8px;"> <div style=" background:#F8F8F8; line-height:0; margin-top:40px; padding:26.15740740740741% 0; text-align:center; width:100%;"> <div style=" background:url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACwAAAAsCAMAAAApWqozAAAABGdBTUEAALGPC/xhBQAAAAFzUkdCAK7OHOkAAAAMUExURczMzPf399fX1+bm5mzY9AMAAADiSURBVDjLvZXbEsMgCES5/P8/t9FuRVCRmU73JWlzosgSIIZURCjo/ad+EQJJB4Hv8BFt+IDpQoCx1wjOSBFhh2XssxEIYn3ulI/6MNReE07UIWJEv8UEOWDS88LY97kqyTliJKKtuYBbruAyVh5wOHiXmpi5we58Ek028czwyuQdLKPG1Bkb4NnM+VeAnfHqn1k4+GPT6uGQcvu2h2OVuIf/gWUFyy8OWEpdyZSa3aVCqpVoVvzZZ2VTnn2wU8qzVjDDetO90GSy9mVLqtgYSy231MxrY6I2gGqjrTY0L8fxCxfCBbhWrsYYAAAAAElFTkSuQmCC); display:block; height:44px; margin:0 auto -44px; position:relative; top:-22px; width:44px;"></div></div> <p style=" margin:8px 0 0 0; padding:0 4px;"> <a href="https://www.instagram.com/p/BcF0Rlyh-IL/" style=" color:#000; font-family:Arial,sans-serif; font-size:14px; font-style:normal; font-weight:normal; line-height:17px; text-decoration:none; word-wrap:break-word;" target="_blank">Docker Hub Multiple tags without branch or Dockerfiles #docker https://nouchka.katagena.com/2017/11/29/docker-multiple-tags-with-one-branch/</a></p> <p style=" color:#c9c8cd; font-family:Arial,sans-serif; font-size:14px; line-height:17px; margin-bottom:0; margin-top:8px; overflow:hidden; padding:8px 0 7px; text-align:center; text-overflow:ellipsis; white-space:nowrap;">A post shared by Nouchka (@nouchkablog) on <time style=" font-family:Arial,sans-serif; font-size:14px; line-height:17px;" datetime="2017-11-29T19:28:16+00:00">Nov 29, 2017 at 11:28am PST</time></p></div></blockquote>
<script async defer src="//platform.instagram.com/en_US/embeds.js"></script>

The github repository of this example: [nouchka/docker-hubtest][3]. This was inspired by a [feature request on Docker Hub Github][4].

 [1]: https://docs.docker.com/docker-cloud/builds/automated-build/
 [2]: https://docs.docker.com/docker-cloud/builds/advanced/#custom-build-phase-hooks
 [3]: https://github.com/nouchka/docker-hubtest
 [4]: https://github.com/docker/hub-feedback/issues/508
