FROM docker.io/golang:alpine as builder

COPY . /src
WORKDIR /src

ENV CGO_ENABLED=0

RUN apk add git && ./build && go build -o /src/genkeys cmd/genkeys/main.go

FROM docker.io/alpine

COPY --from=builder /src/synthesis /usr/bin/synthesis
COPY --from=builder /src/synthesisctl /usr/bin/synthesisctl
COPY --from=builder /src/genkeys /usr/bin/genkeys
COPY contrib/docker/entrypoint.sh /usr/bin/entrypoint.sh

# RUN addgroup -g 1000 -S synthesis-network \
#  && adduser -u 1000 -S -g 1000 --home /etc/synthesis-network synthesis-network
#
# USER synthesis-network
# TODO: Make running unprivileged work

VOLUME [ "/etc/synthesis-network" ]

ENTRYPOINT [ "/usr/bin/entrypoint.sh" ]
