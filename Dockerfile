FROM thevlang/vlang:latest AS builder
COPY . .
RUN v -prod -cc gcc -cflags -static -cflags -s -d habraview_version=$(git describe --tags) . -o /habraview

FROM scratch AS prod
COPY --from=builder /habraview .
ENTRYPOINT ["/habraview"]
