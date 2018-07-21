FROM golang:alpine as build-env
LABEL maintainer="keerthi.ramanarayan@philips.com"

ADD . $GOPATH/src/github.com/hsdp/terraform-provider-hsdp
RUN apk add --no-cache git openssh
WORKDIR $GOPATH/src/github.com/hsdp/terraform-provider-hsdp
RUN go get . && go build .
RUN ls -alhR

FROM hashicorp/terraform:light
ENV GOPATH /go
ENV HOME /root
COPY --from=build-env $GOPATH/src/github.com/hsdp/terraform-provider-hsdp/terraform-provider-hsdp $HOME/terraform.d/plugins/linux_amd64/terraform-provider-hsdp
ENTRYPOINT ["/bin/terraform"]