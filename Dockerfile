FROM buildpack-deps:jessie-scm

# gcc for cgo
RUN apt-get update && apt-get install -y --no-install-recommends \
		g++ \
		gcc \
		libc6-dev \
		make \
	&& rm -rf /var/lib/apt/lists/*

#binaries for bootstrap
RUN mkdir /bootstrap
RUN curl -fsSL "https://golang.org/dl/go1.7.1.linux-amd64.tar.gz" -o golang.tar.gz \
	&& echo "43ad621c9b014cde8db17393dc108378d37bc853aa351a6c74bf6432c1bbd182  golang.tar.gz" | sha256sum -c - \
	&& tar -C /bootstrap -xzf golang.tar.gz \
	&& rm golang.tar.gz

ENV GOROOT_BOOTSTRAP /bootstrap/go

#clone and build
WORKDIR /usr/local
RUN git clone https://go.googlesource.com/go
WORKDIR /usr/local/go/src
RUN /usr/local/go/src/make.bash
RUN ls /usr/local/go/bin

RUN rm -rf /bootstrap

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH
