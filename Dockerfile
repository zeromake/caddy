FROM golang:1.16-alpine
LABEL maintainer="zeromake<a390720046@gmail.com>"

RUN mkdir -p /data
WORKDIR /data

COPY . /data/
RUN export VERSION=`git describe --tags 2>/dev/null | cut -c 2-` && echo $VERSION && cd /data && go build -ldflags='-X github.com/caddyserver/caddy/versions.Version=$(VERSION)' -v -o _bin/caddy ./caddy

FROM alpine:3.13

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && apk add --no-cache ca-certificates tzdata
RUN mkdir -p /etc/caddy && touch /etc/caddy/Caddyfile

COPY --from=0 /data/_bin/caddy /usr/local/bin/

CMD /usr/local/bin/caddy -conf /etc/caddy/Caddyfile
