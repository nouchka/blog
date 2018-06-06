TMP_DIRECTORY=/tmp/blog

.DEFAULT_GOAL := build

build:
	hugo

theme-update:
	git submodule update --remote --merge

test: theme-update
	hugo server --bind 0.0.0.0

clean:
	rm -rf $(TMP_DIRECTORY)/public/*

publish: build
	mkdir -p public/feed/
	cp public/index.xml public/feed/index.html
