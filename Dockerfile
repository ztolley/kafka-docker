FROM openjdk:8u292-jdk

ARG kafka_version=2.8.1
ARG scala_version=2.13
ARG glibc_version=2.31-r0
ARG vcs_ref=unspecified
ARG build_date=unspecified

LABEL org.label-schema.name="kafka" \
    org.label-schema.description="Apache Kafka" \
    org.label-schema.build-date="${build_date}" \
    org.label-schema.vcs-url="https://github.com/wurstmeister/kafka-docker" \
    org.label-schema.vcs-ref="${vcs_ref}" \
    org.label-schema.version="${scala_version}_${kafka_version}" \
    org.label-schema.schema-version="1.0" \
    maintainer="wurstmeister"

ENV KAFKA_VERSION=$kafka_version \
    SCALA_VERSION=$scala_version \
    KAFKA_HOME=/opt/kafka \
    GLIBC_VERSION=$glibc_version

ENV PATH=${PATH}:${KAFKA_HOME}/bin

COPY broker-list.sh create-topics.sh download-kafka.sh start-kafka.sh versions.sh /tmp/

RUN apt upgrade -y 
RUN apt-get update -y 
RUN apt-get install apt-utils -y
RUN apt-get install bash -y
RUN apt-get install curl -y
RUN apt-get install docker -y
RUN apt-get install sudo -y
RUN apt-get install jq -y 
RUN chmod a+x /tmp/*.sh 
RUN mv /tmp/start-kafka.sh /usr/bin
RUN mv /tmp/broker-list.sh /usr/bin 
RUN mv /tmp/create-topics.sh /usr/bin 
RUN mv /tmp/versions.sh /usr/bin 
RUN ls -a /tmp
RUN sync
RUN ls -l /tmp 
RUN cat /tmp/download-kafka.sh
RUN /tmp/download-kafka.sh
RUN tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt 
RUN rm /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz 
RUN ln -s /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} ${KAFKA_HOME} 
RUN rm -rf /tmp/*

COPY overrides /opt/overrides

VOLUME ["/kafka"]

# Use "exec" form so that it runs as PID 1 (useful for graceful shutdown)
CMD ["start-kafka.sh"]