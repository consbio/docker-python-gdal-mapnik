FROM consbio/python3.6-gdal2

ENV MAPNIK_VERSION 3.0.16
ENV PYTHON python2
ENV PATH /usr/local/bin:$PATH

WORKDIR /tmp

RUN apt-get -y update && apt install -y wget build-essential libbz2-dev \
    libsqlite3-dev libreadline-dev libncurses-dev libssl-dev libz-dev \
    liblzma-dev git python wget libharfbuzz-dev \
    libfreetype6-dev libjpeg-dev libproj-dev libpng-dev libwebp-dev \
    libtiff5-dev libpq-dev libcairo-dev libicu-dev

RUN wget https://dl.bintray.com/boostorg/release/1.66.0/source/boost_1_66_0.tar.gz
RUN tar -xf boost*
RUN (cd boost* && ./bootstrap.sh \
    --with-libraries=python,filesystem,system,regex,program_options,thread \
    --with-icu=/usr/lib/x86_64-linux-gnu/ && \
    CPLUS_INCLUDE_PATH=/usr/local/include/python3.6m/ ./b2 -j 2 install)

RUN git clone https://github.com/mapnik/mapnik.git
RUN (cd mapnik && git checkout v${MAPNIK_VERSION} && \
    git submodule update --init && python2 scons/scons.py configure \
    ICU_LIB=/usr/lib/x86_64-linux-gnu/ JOBS=2 && \
    python2 scons/scons.py INPUT_PLUGINS=all && python2 scons/scons.py install)

RUN git clone https://github.com/mapnik/python-mapnik.git
RUN (cd python-mapnik && git checkout v${MAPNIK_VERSION} && \
    python setup.py install)

RUN rm -Rf *

WORKDIR /root