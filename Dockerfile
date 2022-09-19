FROM ubuntu:jammy

WORKDIR /build

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
    git build-essential bison gperf texinfo autoconf wget \
    gettext autopoint rsync tar xz-utils

RUN git clone git://git.sv.gnu.org/coreutils
WORKDIR /build/coreutils

# Cannot be built as root, but requires sudo permissions
RUN groupadd -r docker
RUN useradd -r -g docker docker
RUN usermod -aG sudo docker
RUN mkdir /home/docker

# Make git shut up about repository ownership
RUN chown -R docker /build/coreutils
RUN git config --global --add safe.directory /build/coreutils

USER docker

RUN bash ./bootstrap
RUN bash ./configure
RUN make

WORKDIR /build/coreutils/src
RUN rm -rf *.c *.h *.o *.a *.mk *.hin blake2 extract-magic
RUN mkdir docker && tar -zcvf coreutils.tar.gz /build/coreutils/src -C /docker
