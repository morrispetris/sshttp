# Use an official Ubuntu as a parent image
FROM ubuntu:18.04

# Install necessary dependencies
RUN apt-get update && \
    apt-get -y install curl git gcc make openssh-server

# Install Golang
RUN curl -SL https://golang.org/dl/go1.18.10.linux-amd64.tar.gz | tar -C /usr/local -xzf -

# Set envionment variables for Golang
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

# Create and navigate to the project directory
WORKDIR /go/src/github.com/morrispetris/sshttp/

# Copy the Go project to the container
COPY . .

# Install dependencies
RUN go get -d -v ./...

# Build the Go project
RUN go build -o sshttp 

# Expose the necessary port(s)
EXPOSE 8080

# Start the app
CMD ["./sshttp", "--listenOn=127.0.0.1:8080", "--forwardTo=22", "--clientAuth=false"]
