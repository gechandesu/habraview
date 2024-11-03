all: build

build:
	v -o habraview src

prod:
	v -o habraview -prod -cc clang -compress src
