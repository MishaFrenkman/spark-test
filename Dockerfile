ARG version=3.6.2

FROM rocker/r-ver:${version} AS base

RUN apt-get update \
  && apt-get install -y --no-install-recommends libxml2-dev libcurl4-openssl-dev libssl-dev libgit2-dev zlib1g-dev software-properties-common \
  && rm -rf /var/lib/apt/lists/*

# java 8 workaround
RUN apt update -y \
  && apt install apt-transport-https ca-certificates wget dirmngr gnupg software-properties-common -y \
  && wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - \
  && add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ \
  && apt update -y && apt install adoptopenjdk-8-hotspot -y \
  && update-alternatives --config java \
  && export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java

WORKDIR /app

RUN R -e "install.packages(c('sparklyr', 'dplyr', 'nycflights13', 'Lahman'))"

ARG SPARK_VERSION=2.4.3
ENV SPARK_VERSION=${SPARK_VERSION}

COPY Install_Spark.R Install_Spark.R
RUN R -f Install_Spark.R

COPY Main.R Main.R

ENV SPARK_URL=spark://spark-master-0.spark-headless.spark.svc.cluster.local:7077
ENV EXECUTOR_MEMORY=4GB

CMD ["R", "-f", "Main.R"]
