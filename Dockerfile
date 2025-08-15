# syntax=docker/dockerfile:1
# see https://docs.docker.com/guides/golang/build-images/

FROM docker.io/library/golang:1.14.0

# Set destination for COPY
WORKDIR /app

# Download Go modules
#COPY go.mod go.sum ./
COPY go.mod ./
RUN go mod download

# Copy the source code. Note the slash at the end, as explained in
# https://docs.docker.com/engine/reference/builder/#copy
COPY *.go ./

# Build
RUN CGO_ENABLED=0 GOOS=linux go build -o /isg-apiserver

# Optional:
# To bind to a TCP port, runtime parameters must be supplied to the docker command.
# But we can document in the Dockerfile what ports
# the application is going to listen on by default.
# https://docs.docker.com/engine/reference/builder/#expose
EXPOSE 5432

# ip address of "servicewelt.local"
ENV ISG_IP=192.168.0.101

# Run
CMD /isg-apiserver $ISG_IP
