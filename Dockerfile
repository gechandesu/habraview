FROM debian:bookworm AS vlang
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ca-certificates gcc clang make git binutils libssl-dev libatomic1 && \
    apt clean && rm -rf /var/cache/apt/archives/* && \
    rm -rf /var/lib/apt/lists/*
RUN git clone --depth=1 https://github.com/vlang/v /opt/v && \
    cd /opt/v && \
    make && \
    /opt/v/v symlink && \
    v version

FROM vlang AS builder
COPY . .
RUN v -prod -cflags -static -cflags -s -d hv_version=$(git describe --tags) . -o /habraview

FROM scratch AS prod
COPY --from=builder /habraview .
ENTRYPOINT ["/habraview"]
