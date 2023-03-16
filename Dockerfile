# Use an official Ubuntu as a parent image
FROM ubuntu:18.04

# Install necessary dependencies
RUN apt-get update && \
    apt-get -y install curl git gcc make openssh-server openssl

# Install Golang
RUN curl -SL https://golang.org/dl/go1.18.10.linux-amd64.tar.gz | tar -C /usr/local -xzf -

# cert
RUN openssl req -new -newkey rsa:2048 -nodes -keyout server.key -out server.csr -subj "/C=US/ST=CA/L=San Francisco/O=My Company/OU=IT Department/CN=example.com" 
RUN openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

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
CMD ["./sshttp", "--certPath=./", "--listenOn=127.0.0.1:8080", "--forwardTo=22", "--clientAuth=false"]
