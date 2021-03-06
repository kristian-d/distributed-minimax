FROM golang:alpine AS builder

# must be "leader" or "follower"
ARG SERVICE

# necessary env vars for image
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64 \
    ENV=dev

# move to working directory /build
WORKDIR /build

# copy and download dependency using go mod
# COPY go.mod .
# COPY go.sum .
# RUN go mod download

# copy dir into container
COPY . .

# build application
RUN go build ./cmd/$SERVICE/main.go

# move to /dist directory as the place for resulting binary folder
WORKDIR /dist

# copy binary from build to main folder
RUN cp /build/main .

# build a small image
FROM scratch

COPY --from=builder /dist/main /

# expose ports
EXPOSE 3000 3001

# command to run when starting container
CMD ["/main"]