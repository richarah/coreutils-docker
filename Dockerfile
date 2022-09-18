FROM ubuntu:jammy

WORKDIR /build

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install git build-essential
RUN git clone git://git.sv.gnu.org/coreutils

WORKDIR /build/coreutils
RUN bash ./bootstrap
RUN bash ./configure
RUN make

WORKDIR /build/coreutils/src
RUN rm -rf *.c *.h *.o *.a *.mk *.hin blake2 extract-magic
RUN mkdir docker && tar -zcvf coreutils.tar.gz /build/coreutils/src -C /docker
