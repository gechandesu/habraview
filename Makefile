bin:
	v -prod -skip-unused -cflags -static -d hv_version=$$(git describe --tags) .
