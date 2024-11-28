FROM thevlang/vlang:latest AS builder
COPY . .
RUN v -prod -skip-unused -cc gcc -cflags -static -cflags -s -d hv_version=$(git describe --tags) . -o /habraview

FROM scratch AS prod
COPY --from=builder /habraview .
ENTRYPOINT ["/habraview"]
