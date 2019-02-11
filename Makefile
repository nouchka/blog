.DEFAULT_GOAL := build

build:
	hugo

theme-update:
	git submodule update --remote --merge
	echo "gitdir: ../../.git/modules/themes/hugo-tranquilpeak-theme" > ./themes/hugo-tranquilpeak-theme/.git

test: theme-update
	hugo server --bind 0.0.0.0

publish: build
	mkdir -p public/feed/
	cp public/index.xml public/feed/index.html
