ARG BUILD_FROM
FROM $BUILD_FROM

ARG NAME=openvpnclient

# Add env
ENV LANG C.UTF-8

# install openvpn package
RUN apk add --update openvpn jq python3

# setup python within an virtual environment
RUN python -m venv /$NAME/venv && \
        source source /$NAME/venv/bin/active && \
        pip install --upgrade pip && \
        pip install --upgrade setuptools

# install dependencies
RUN pip install -r requirements

WORKDIR /$NAME/

ADD run.sh /$NAME

ADD . /$NAME/app

# install the configuration
RUN source /$NAME/venv/bin/active && cd /$NAME/work && python setup.py install

ENTRYPOINT [ "./$NAME/run.sh"]