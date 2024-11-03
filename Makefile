bin:
	v -prod -cflags -static -d habraview_version=$$(git describe --tags) .
