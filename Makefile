.PHONY: build run clean thirdparty lint

workdir:=$(shell pwd)
builddir:=$(workdir)/build
thirdpartydir:=$(workdir)/thirdparty

build: 
	@cmake -B${builddir} -DCMAKE_BUILD_TYPE=Debug .
	@cd ${builddir} && make -j4

run: build
	@cp cmd/worker/config.ini ${builddir}/config.ini
	@cd ${builddir} && ./worker.app $(ARGS)

release:
	@cmake -B${builddir} -DCMAKE_BUILD_TYPE=Release .
	@cd ${builddir} && make -j4

clean:
	@rm -rf ${builddir}

thirdparty:
	@cd ${thirdpartydir}/openssl && ./build.sh
	@cd ${thirdpartydir}/libhv && ./build.sh

lint:
	@cpplint --verbose=1 ./cmd/*/*.cc
	@cpplint --verbose=1 ./src/**/*.h
	@cpplint --verbose=1 ./src/**/*.cc
	@cpplint --verbose=1 ./src/**/**/*.h
	@cpplint --verbose=1 ./src/**/**/*.cc
	@cpplint --verbose=1 ./src/**/**/**/*.h
	@cpplint --verbose=1 ./src/**/**/**/*.cc