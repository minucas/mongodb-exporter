FROM golang:alpine as builder

RUN set -x \
 && apk --no-cache add git make \
 && git clone --branch v0.6.2 --depth 1 https://github.com/percona/mongodb_exporter.git /go/src/github.com/percona/mongodb_exporter \
 && cd /go/src/github.com/percona/mongodb_exporter \
 && make build

FROM alpine:3.4

LABEL maintainer "min"
LABEL version "0.6.2"
LABEL description "Docker Image of Mongodb Exporter"

EXPOSE 9216

RUN apk --no-cache add --update ca-certificates
COPY --from=builder /go/src/github.com/percona/mongodb_exporter/mongodb_exporter /bin/mongodb_exporter

ENTRYPOINT [ "/bin/mongodb_exporter" ]

#CMD ["-web.listen-address", ":9216", "-mongodb.uri", "mongodb://127.0.0.1:27017", "-collect.database", "true"]
