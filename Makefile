TMP_DIRECTORY=/tmp/blog

.DEFAULT_GOAL := build


build: sync generate

sync:
	rsync -rzv --delete \
		--exclude '.git/' \
		--exclude 'README.md' \
		--exclude '.project' \
		--exclude 'Makefile' \
		--exclude 'themes/' \
		--exclude 'public/' \
		. $(TMP_DIRECTORY)/
generate:
	cd $(TMP_DIRECTORY)/; hugo

theme-clone:
	mkdir -p $(TMP_DIRECTORY)/themes/; \
		[ -d "$(TMP_DIRECTORY)/themes/hugo-tranquilpeak-theme/" ] || git clone https://github.com/kakawait/hugo-tranquilpeak-theme.git $(TMP_DIRECTORY)/themes/hugo-tranquilpeak-theme/

test: theme-clone sync generate
	docker-compose up -d
	echo http://localhost:8000/

clean:
	rm -rf $(TMP_DIRECTORY)/public/*

publish-url:
	sed -i "s/http:\/\/localhost:8000/https:\/\/nouchka.katagena.com/" $(TMP_DIRECTORY)/config.toml

publish: clean theme-clone sync publish-url generate
	mkdir -p $(TMP_DIRECTORY)/public/feed/
	cp $(TMP_DIRECTORY)/public/index.xml $(TMP_DIRECTORY)/public/feed/index.html
	[ ! -d "../githubio/" ] ||rsync -rzv --delete \
		--exclude '.git/' \
		--exclude '.project' \
		--exclude 'CNAME' \
		--exclude 'google944c745deab0617a.html/' \
		--exclude 'robots.txt' \
		$(TMP_DIRECTORY)/public/ ../githubio/
	sleep 20
	cd ../githubio/; git pull; git add -A; git st; git commit -m 'New post'; git push
