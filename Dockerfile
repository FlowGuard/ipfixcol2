FROM ubuntu:bionic

# install req packages
RUN apt-get update
RUN apt-get install -y -q git gcc g++ cmake make python3-docutils zlib1g-dev librdkafka-dev libxml2-dev liblz4-dev libzstd-dev

# build libfds
RUN cd /tmp \ 
&& git clone https://github.com/CESNET/libfds.git \
&& cd libfds \
&& mkdir build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr \
&& make \
&& make install

#build ipfixcol2 (using devel branch because of kafka support)
RUN cd /tmp \
&& git clone https://github.com/FlowGuard/ipfixcol2.git \
&& cd ipfixcol2 \
&& git checkout devel \ 
&& mkdir build && cd build && cmake .. \ 
&& make \
&& make install

# config directory
RUN mkdir -p /usr/local/etc/ipfixcol2/
EXPOSE 4739 4739/udp

VOLUME /usr/local/etc/ipfixcol2/

ENTRYPOINT [ "ipfixcol2" ]
