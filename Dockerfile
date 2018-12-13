FROM alpine:edge AS base
RUN apk update
RUN apk upgrade
RUN apk add --update go gcc g++
RUN mkdir /go
WORKDIR /go
COPY . .
RUN apk add --no-cache git mercurial
RUN go get -d . \
    && CC=$(which musl-gcc) go build --ldflags '-w -linkmode external -extldflags "-static"' main.go

FROM alpine:edge
RUN apk add --no-cache ca-certificates
WORKDIR /home/go
COPY --from=base /go/main /home/go
EXPOSE 9100
CMD ["./main"]
