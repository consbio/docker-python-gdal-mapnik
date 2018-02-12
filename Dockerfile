FROM consbio/python3.6-gdal2

ENV MAPNIK_VERSION 3.0.16
ENV PYTHON python2
ENV PATH /usr/local/bin:$PATH

WORKDIR /tmp

RUN apt-get -y update && apt install -y wget build-essential libbz2-dev \
    libsqlite3-dev libreadline-dev libncurses-dev libssl-dev libz-dev \
    liblzma-dev git python libboost-all-dev libharfbuzz-dev libfreetype6-dev \
    libjpeg-dev libproj-dev libpng-dev libwebp-dev libtiff5-dev libpq-dev \
    libcairo-dev

RUN git clone https://github.com/mapnik/mapnik.git
RUN (cd mapnik && git checkout v${MAPNIK_VERSION} && \
    git submodule update --init && python2 scons/scons.py configure && \
    python2 scons/scons.py && python2 scons/scons.py install)

RUN rm -Rf *

WORKDIR /root