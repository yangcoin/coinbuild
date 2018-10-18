FROM ubuntu:14.04

MAINTAINER yangchigi@yangchigi.com

RUN apt-get update

RUN apt-get install -y git build-essential wget pkg-config curl libtool autotools-dev \
     automake libssl-dev libevent-dev bsdmainutils
    

WORKDIR /


ENV WIN_PACKAGE="python3 nsis g++-mingw-w64-x86-64"

ENV WINE_PACKAGE="wine1.6 bc"

RUN apt-get install -y software-properties-common

RUN add-apt-repository ppa:wine/wine-builds

RUN apt-get update&&apt-get install -y  --install-recommends  ${WIN_PACKAGE}

RUN dpkg --add-architecture i386
RUN apt-get update


RUN  echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula boolean true" \
  | debconf-set-selections \
    apt-get install  ttf-mscorefonts-installer

RUN apt-get install -y   --no-install-recommends --no-upgrade -qq   ${WINE_PACKAGE}

ENV GIT_YANG=https://github.com/yangcoin/yangcoin.git
ENV YANG_BRANCH=yangcoin
RUN mkdir -p yangcoin &&git clone --depth=5 ${GIT_YANG} -b ${YANG_BRANCH} yangcoin

ENV COIN=https://github.com/yangcoin/yangcoin.git
ENV COIN_BRANCH=yangcoin

ENV COIN=https://github.com/yangcoin/yangcoin.git
ENV COIN_BRANCH=yangcoin
RUN mkdir -p /coin &&git clone --depth=5 ${COIN} -b ${COIN_BRANCH} coin

WORKDIR /yangcoin

RUN ./autogen.sh

RUN cd depends && make HOST=x86_64-w64-mingw32 -j4

WORKDIR /coin

RUN git pull

RUN ./autogen.sh

RUN ./configure --prefix=/yangcoin/depends/x86_64-w64-mingw32 \
    LDFLAGS=" -static-libstdc++" \
    --disable-gui-tests \
    --enable-reduce-exports \
    --with-gui \
    --enable-static     

RUN make deploy

WORKDIR /bitcoin

RUN ./autogen.sh


RUN ./configure CPPFLAGS="-I${BDB_PREFIX}/include/ -O2" \
    LDFLAGS="-L${BDB_PREFIX}/lib/ -static-libstdc++" \
    --with-gui --prefix=${BTCPREFIX} \
    --disable-ccache \
    --disable-maintainer-mode  \
    --disable-dependency-tracking \
    --enable-glibc-back-compat \
    --enable-reduce-exports \
    --disable-bench \
    --disable-gui-tests \
    --enable-static

RUN make 

RUN make install DESTDIR=/bitcoin/bitcoin-${BTCVERSION}

RUN mv /bitcoin/bitcoin-${BTCVERSION}${BTCPREFIX} /bitcoin-${BTCVERSION} && strip /bitcoin-${BTCVERSION}/bin/* && rm -rf /bitcoin-${BTCVERSION}/lib/pkgconfig && find /bitcoin-${BTCVERSION} -name "lib*.la" -delete && find /bitcoin-${BTCVERSION} -name "lib*.a" -delete 

WORKDIR /

RUN tar cvf bitcoin-${BTCVERSION}.tar bitcoin-${BTCVERSION} 