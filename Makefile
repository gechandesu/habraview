bin:
	v -prod -cflags -static -d hv_version=$$(git describe --tags) .
