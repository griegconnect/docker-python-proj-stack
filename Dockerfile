FROM python:3.8.5-slim

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    DOCKER_CONTAINER=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY_VERSION=1.1.4 \
    POETRY_HOME="/opt/poetry" \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_NO_INTERACTION=1 \
    PYSETUP_PATH="/opt/pysetup" \
    PROJ_VERSION="proj-8.0.0"

ENV PATH="$PATH:$POETRY_HOME/bin"
RUN apt-get update && apt-get install --no-install-recommends -y apt-utils ca-certificates curl build-essential git default-libmysqlclient-dev gcc bash sqlite3 libcurl4-gnutls-dev libsqlite3-dev libtiff-dev pkg-config -y
RUN apt-get -qy autoremove
RUN curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python
RUN mkdir /proj && cd /proj && curl -sSL https://download.osgeo.org/proj/${PROJ_VERSION}.tar.gz --output proj.tar.gz && tar xvzf proj.tar.gz && cd ${PROJ_VERSION} && ./configure && make && make install && rm -fR *.gz ${PROJ_VERSION}/src
WORKDIR $PYSETUP_PATH
ENV LD_LIBRARY_PATH="/lib:/usr/lib:/usr/local/lib"
#RUN curl -sSL https://sdk.cloud.google.com | bash > /dev/null
ENV PATH $PATH:/root/google-cloud-sdk/bin/
