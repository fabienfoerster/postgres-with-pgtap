ARG POSTGRES_VERSION="14-alpine"
ARG PGTAP_VERSION="v1.3.3"

FROM postgres:${POSTGRES_VERSION}

COPY init-pgtap-extension.sql /docker-entrypoint-initdb.d/

# TODO: move musl-locale to a builder image
# TODO: move pgtap to a builder image
RUN set -ex && \
    apk add --no-cache make && \
    apk add --no-cache --virtual .build-dependencies \
    cmake make musl-dev gcc gettext-dev libintl \
    postgresql \
    postgresql-contrib \
    build-base \
    patch \
    diffutils \
    git \
    perl && \
    git clone git://github.com/theory/pgtap.git && \
        chown -R postgres:postgres pgtap/ && \
        cd pgtap/ && \
        git checkout ${PGTAP_VERSION} && \
        make && make install && \
    apk del .build-dependencies
