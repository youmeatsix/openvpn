ARG BUILD_FROM
FROM $BUILD_FROM

ARG NAME=openvpnclient

# Add env
ENV LANG C.UTF-8

# install openvpn package
RUN apk add --update --no-cache openvpn jq python3 bash python3-dev \
    python \
    python-dev \
    build-base \
    linux-headers \
    pcre-dev \
    py-pip \
    curl \
    openssl

# setup python within an virtual environment
RUN python3 -m venv /$NAME/venv && \
        source /$NAME/venv/bin/activate && \
        pip install --upgrade pip && \
        pip install --upgrade setuptools && \
        pip install uwsgi

WORKDIR /$NAME/

ADD run.sh /$NAME

ADD . /$NAME/app

# install the configuration
RUN source /$NAME/venv/bin/activate && cd /$NAME/app && python setup.py install

# expose name of working dir to environment so that is known by bash to call the run.sh script
ENV NAME $NAME
ENTRYPOINT /bin/bash /$NAME/run.sh