# hadolint ignore=DL3007
FROM registry.gitlab.com/pages/hugo:latest as builder
LABEL maintainer="Jean-Avit Promis docker@katagena.com"

LABEL org.label-schema.vcs-url="https://gitlab.com/katagena/blog"
LABEL version="latest"

COPY . /blog/
WORKDIR /blog/
RUN hugo

# hadolint ignore=DL3007
FROM nginx:latest
COPY --from=builder /blog/public /usr/share/nginx/html

##Kubernetes port 5000
RUN sed -i "s/80;/80;\n    listen\t 5000;/" /etc/nginx/conf.d/default.conf
EXPOSE 5000

