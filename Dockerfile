FROM alpine:3.23

RUN apk add --no-cache jq sqlite coreutils

WORKDIR /opt/test-runner
COPY . .
ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
