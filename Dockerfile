# Use an official Ubuntu as a parent image
FROM ubuntu:18.04

# Install necessary dependencies
RUN apt-get update && \
    apt-get -y install curl git gcc make

# Install Golang
RUN curl -SL https://golang.org/dl/go1.15.2.linux-amd64.tar.gz | tar -C /usr/local -xzf -

# Set envionment variables for Golang
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

# Create and navigate to the project directory
WORKDIR /go/src/github.com/morrispetris/sshttp/

# Copy the Go project to the container
COPY . .

# Build the Go project
RUN go build

# Expose the necessary port(s)
EXPOSE 8080

# Start the app
CMD ["/go/src/github.com/ymorrispetris/sshttp/app"]
