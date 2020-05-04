# Build
FROM ubuntu as build
LABEL maintainer=francois.allais@sogeti.com

WORKDIR /hugo
COPY ./ /hugo/

RUN apt update && \
    apt install -y wget ca-certificates && \
    wget https://github.com/gohugoio/hugo/releases/download/v0.69.2/hugo_0.69.2_Linux-64bit.tar.gz && \
    tar xzf hugo_0.69.2_Linux-64bit.tar.gz && \
    rm -r hugo_0.69.2_Linux-64bit.tar.gz && \
    ./hugo

# Setup
FROM abiosoft/caddy
LABEL maintainer=francois.allais@sogeti.com

COPY --from=build /hugo/public/ /srv/
COPY ./Caddyfile /etc/Caddyfile

EXPOSE 2015
CMD ["--conf", "/etc/Caddyfile", "--log", "stdout"]