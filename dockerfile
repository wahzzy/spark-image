FROM apache/spark:3.5.6-scala2.12-java11-python3-ubuntu

USER root

# fix CVE-2024-47561
RUN rm /opt/spark/jars/avro-ipc-1.11.4.jar
RUN cd /opt/spark/jars && \
    wget -q https://repo1.maven.org/maven2/org/apache/avro/avro-ipc/1.12.0/avro-ipc-1.12.0.jar

# fix CVE-2019-10202
RUN rm /opt/spark/jars/jackson-mapper-asl-1.9.13.jar
RUN cd /opt/spark/jars && \
    wget -q https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-core/2.15.4/jackson-core-2.15.4.jar && \
    wget -q https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-databind/2.15.4/jackson-databind-2.15.4.jar && \
    wget -q https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-annotations/2.15.4/jackson-annotations-2.15.4.jar

# # fix CVE-2019-0205
RUN rm /opt/spark/jars/libthrift-0.12.0.jar
RUN cd /opt/spark/jars && \
    wget https://repo1.maven.org/maven2/org/apache/thrift/libthrift/0.13.0/libthrift-0.13.0.jar

# # fix CVE-2018-1330
RUN rm /opt/spark/jars/mesos-1.4.3-shaded-protobuf.jar
RUN cd /opt/spark/jars && \
    wget https://repo1.maven.org/maven2/org/apache/mesos/mesos/1.7.2/mesos-1.7.2-shaded-protobuf.jar || \
    wget https://repo1.maven.org/maven2/org/apache/mesos/mesos/1.7.2/mesos-1.7.2.jar

# # fix GHSA-xpw8-rcwv-8f8p
RUN rm -f /opt/spark/jars/netty-*-4.1.96.Final.jar
RUN cd /opt/spark/jars && \
    wget https://repo1.maven.org/maven2/io/netty/netty-all/4.1.100.Final/netty-all-4.1.100.Final.jar && \
    wget https://repo1.maven.org/maven2/io/netty/netty-buffer/4.1.100.Final/netty-buffer-4.1.100.Final.jar && \
    wget https://repo1.maven.org/maven2/io/netty/netty-codec-http2/4.1.100.Final/netty-codec-http2-4.1.100.Final.jar && \
    wget https://repo1.maven.org/maven2/io/netty/netty-codec-http/4.1.100.Final/netty-codec-http-4.1.100.Final.jar && \
    wget https://repo1.maven.org/maven2/io/netty/netty-codec/4.1.100.Final/netty-codec-4.1.100.Final.jar && \
    wget https://repo1.maven.org/maven2/io/netty/netty-codec-socks/4.1.100.Final/netty-codec-socks-4.1.100.Final.jar && \
    wget https://repo1.maven.org/maven2/io/netty/netty-common/4.1.100.Final/netty-common-4.1.100.Final.jar && \
    wget https://repo1.maven.org/maven2/io/netty/netty-handler/4.1.100.Final/netty-handler-4.1.100.Final.jar && \
    wget https://repo1.maven.org/maven2/io/netty/netty-handler-proxy/4.1.100.Final/netty-handler-proxy-4.1.100.Final.jar && \
    wget https://repo1.maven.org/maven2/io/netty/netty-resolver/4.1.100.Final/netty-resolver-4.1.100.Final.jar && \
    wget https://repo1.maven.org/maven2/io/netty/netty-transport/4.1.100.Final/netty-transport-4.1.100.Final.jar && \
    wget https://repo1.maven.org/maven2/io/netty/netty-transport-classes-epoll/4.1.100.Final/netty-transport-classes-epoll-4.1.100.Final.jar && \
    wget https://repo1.maven.org/maven2/io/netty/netty-transport-classes-kqueue/4.1.100.Final/netty-transport-classes-kqueue-4.1.100.Final.jar && \
    wget https://repo1.maven.org/maven2/io/netty/netty-transport-native-epoll/4.1.100.Final/netty-transport-native-epoll-4.1.100.Final.jar && \
    wget https://repo1.maven.org/maven2/io/netty/netty-transport-native-kqueue/4.1.100.Final/netty-transport-native-kqueue-4.1.100.Final.jar && \
    wget https://repo1.maven.org/maven2/io/netty/netty-transport-native-unix-common/4.1.100.Final/netty-transport-native-unix-common-4.1.100.Final.jar

RUN apt-get update
# fix CVE-2025-5222
RUN apt-get remove -y libicu66
# fix CVE-2025-4802
RUN apt-get install -y libc-bin locales

# # fix CVE-2025-48734
# RUN apt-get install -y unzip
# RUN unzip /opt/spark/jars/hadoop-client-runtime-3.3.4.jar -d ./hadoop-client-extracted/
# # Remove vulnerable commons-beanutils
# RUN find ./hadoop-client-extracted/ -name "*beanutils*" -exec rm -rf {} +

# upgrade Python to 3.10
RUN apt install software-properties-common -y
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt install python3.10 -y
RUN apt-get purge --auto-remove -y python3.8 python3
RUN ln -s python3.10 /usr/bin/python3

RUN chown -R spark:spark /opt/spark

# USER spark
