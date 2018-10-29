# VERSION 0.9.0.0
# AUTHOR: Xinbin Huang
# DESCRIPTION: A simple Docker image to run Airflow
# BUILD: docker build --rm -t xinbinhuang/airflow-docker .
# SOURCE: https://github.com/xinbinhuang/airflow-docker

FROM ubuntu:18.04
LABEL maintainer="Xinbin Huang"

# Stops interactive installation/configuration
ARG DEBIAN_FRONTEND=noninteractive

# Airflow
ARG AIRFLOW_VERSION=1.10.0
ENV AIRFLOW_HOME /usr/local/airflow
ENV AIRFLOW_DAGS ${AIRFLOW_HOME}/dags
ENV AIRFLOW_GPL_UNIDECODE yes
# Extra packages to install: https://airflow.apache.org/installation.html
ARG AIRFLOW_EXTRAS="[s3,crypto,celery,postgres,hive,jdbc,mysql,ssh]"

# Copy dependencies for airflow
WORKDIR /requirements
COPY    requirements/airflow.txt /requirements/airflow.txt

RUN set -ex \
    && apt-get update \
    && apt-get upgrade -yqq \
    && apt-get install -yqq --no-install-recommends \
        freetds-dev \
        freetds-bin \
        build-essential \
        libkrb5-dev \
        libsasl2-dev \
        libssl-dev \
        libffi-dev \
        libblas-dev \
        liblapack-dev \
        libpq-dev \
        apt-utils \
        git \
        python3-pip \
        python3-dev \
        mysql-client \
        mysql-server \
        curl \
        default-libmysqlclient-dev \
        vim-tiny 

RUN set -ex \
    && pip3 install -U setuptools wheel \
    && pip3 install -r /requirements/airflow.txt \
    && SLUGIFY_USES_TEXT_UNIDECODE=yes pip3 install apache-airflow${AIRFLOW_EXTRAS}==${AIRFLOW_VERSION} \
    && apt-get autoremove -yqq \
    && apt-get autoclean \
    && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/doc \
        /usr/share/doc-base 

COPY script/entrypoint.sh ${AIRFLOW_HOME}/entrypoint.sh
COPY config/airflow.cfg ${AIRFLOW_HOME}/airflow.cfg
COPY dags/ ${AIRFLOW_DAGS}

RUN useradd -ms /bin/bash -d ${AIRFLOW_HOME} airflow
RUN chown -R airflow: ${AIRFLOW_HOME} \
    &&  chmod +x ${AIRFLOW_HOME}/entrypoint.sh

EXPOSE 8080 8793

USER airflow
WORKDIR ${AIRFLOW_HOME}
ENTRYPOINT ["./entrypoint.sh"]

