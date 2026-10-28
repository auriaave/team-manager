FROM docker.io/library/golang:1.27.3@sha256:2920bb124f1a2e12a1d39f0cab756ae0068441ee1da7655dec7f5e374944095b as builder
LABEL maintainer="maintainer@cilium.io"
ADD . /go/src/github.com/cilium/team-manager
WORKDIR /go/src/github.com/cilium/team-manager
RUN make team-manager
RUN strip team-manager

FROM docker.io/library/alpine:3.22.2@sha256:4b7ce07002c69e8f3d704a9c5d6fd3053be500b7f1c69fc0d80990c2ad8dd412 as certs
RUN apk --update add ca-certificates

FROM scratch
LABEL maintainer="maintainer@cilium.io"
COPY --from=builder /go/src/github.com/cilium/team-manager/team-manager /usr/bin/team-manager
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
ENTRYPOINT ["/usr/bin/team-manager"]
