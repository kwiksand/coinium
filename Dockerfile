FROM ubuntu:latest

RUN useradd -r coinium && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb http://download.mono-project.com/repo/ubuntu xenial main" | tee /etc/apt/sources.list.d/mono-official.list && \
    apt-get update && \
    apt-get install -y ntp git build-essential libssl-dev libdb-dev libdb++-dev libboost-all-dev libqrencode-dev autoconf automake pkg-config unzip curl wget make mono-devel


RUN mkdir /home/coinium && \
    chmod 777 /home/coinium

USER coinium
ENV TZ /usr/share/zoneinfo/Etc/UTC

RUN cd /home/coinium && \
    mkdir .ssh && \
    chmod 700 .ssh && \
    cd /home/coinium && \
    ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts && \
    git clone https://github.com/CoiniumServ/CoiniumServ.git && \
    cd CoiniumServ && \
    git submodule init && \
    git submodule update && \
    cd build/release && \
    ./build.sh

#VOLUME ["/home/coinium/.coinium"]

USER root

ENV GOSU_VERSION=1.10

# Install GoSU
RUN gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
  && curl -o /usr/local/bin/gosu -L https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture) \
    && curl -L https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture).asc | gpg --verify - /usr/local/bin/gosu \
    && chmod +x /usr/local/bin/gosu
    
EXPOSE 80


COPY docker-entrypoint.sh /entrypoint.sh

RUN chmod 777 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
#
#CMD ["coiniumd"]
