FROM unbuntu:18.04

# Stops interactive installation/configuration
ARG DEBIAN_FRONTEND=noninteractive

# Airflow
ARG AIRFLOW_VERSION=1.10.0
ENV AIRFLOW_HOME /airflow
ENV AIRFLOW_DAGS ${AIRFLOW_HOME}/dags
ENV AIRFLOW_GPL_UNIDECODE yes
# Extra packages to install: https://airflow.apache.org/installation.html
ARG AIRFLOW_EXTRAS="[s3,crypto,celery,postgres,hive,jdbc,mysql,ssh]"

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
        git \
        python3-pip \
        python3-dev \
        mysql-client \
        mysql-server \
        postgresql \
        curl \
        default-libmysqlclient-dev \
        vim-tiny 

RUN pip install -U pip setuptools wheel \
    && pip install apache-airflow${AIRFLOW_EXTRAS}==${AIRFLOW_VERSION}} \
    && apt-get autoremove -yqq \
    && apt-get autoclean \
    && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/doc \
        /usr/share/doc-base 

EXPOSE 8080

USER airflow
WORKDIR ${AIRFLOW_HOME}}
CMD ["webserver"]


