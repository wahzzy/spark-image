FROM spark:3.4.1-scala2.12-java11-ubuntu

USER root

# fix CVE-2019-10202
RUN rm /opt/spark/jars/jackson-mapper-asl-1.9.13.jar
RUN cd /opt/spark/jars && \
    wget -q https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-core/2.15.4/jackson-core-2.15.4.jar && \
    wget -q https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-databind/2.15.4/jackson-databind-2.15.4.jar && \
    wget -q https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-annotations/2.15.4/jackson-annotations-2.15.4.jar

# fix CVE-2022-1471
RUN rm /opt/spark/jars/snakeyaml-1.33.jar
RUN cd /opt/spark/jars && \
    wget -q https://repo1.maven.org/maven2/org/yaml/snakeyaml/2.0/snakeyaml-2.0-javadoc.jar

RUN apt-get update && apt-get install -y unzip openjdk-11-jdk
 
# fix CVE-2025-32415
RUN apt-get install -y libxml2

# fix CVE-2025-4802
RUN apt-get install -y libc-bin locales libc6

# fix CVE-2020-11023
WORKDIR /tmp
RUN wget -q https://code.jquery.com/jquery-3.5.0.min.js
RUN mkdir /tmp/jquery /tmp/avro-ipc
RUN unzip /opt/spark/jars/avro-ipc-1.11.1.jar -d /tmp/avro-ipc
RUN rm /tmp/avro-ipc/org/apache/avro/ipc/stats/static/jquery-1.4.2.min.js
RUN mv /tmp/jquery-3.5.0.min.js /tmp/avro-ipc/org/apache/avro/ipc/stats/static/jquery-3.5.0.min.js
RUN sed -i 's/jquery-1.4.2.min.js/jquery-3.5.0.min.js/g' /tmp/avro-ipc/org/apache/avro/ipc/stats/templates/statsview.vm
RUN jar cf /opt/spark/jars/avro-ipc-1.11.1.jar -C /tmp/avro-ipc . 
RUN rm -rf /tmp/jquery* /tmp/avro-ipc*

# Fix CVE-2025-48734
RUN mkdir /tmp/hadoop-client-runtime
RUN unzip /opt/spark/jars/hadoop-client-runtime-3.3.4.jar -d /tmp/hadoop-client-runtime/
RUN sed -i 's/1.9.4/1.11.0/g' /tmp/hadoop-client-runtime/META-INF/maven/commons-beanutils/commons-beanutils/pom.*
RUN jar cf /opt/spark/jars/hadoop-client-runtime-3.3.4.jar -C /tmp/hadoop-client-runtime/ .
RUN rm -rf /tmp/hadoop-client-runtime*

# fix CVE-2018-1330
RUN rm /opt/spark/jars/mesos-1.4.3-shaded-protobuf.jar
RUN cd /opt/spark/jars && \
    wget https://repo1.maven.org/maven2/org/apache/mesos/mesos/1.7.2/mesos-1.7.2-shaded-protobuf.jar || \
    wget https://repo1.maven.org/maven2/org/apache/mesos/mesos/1.7.2/mesos-1.7.2.jar

# fix CVE-2019-0205
RUN rm /opt/spark/jars/libthrift-0.12.0.jar
RUN cd /opt/spark/jars && \
    wget https://repo1.maven.org/maven2/org/apache/thrift/libthrift/0.13.0/libthrift-0.13.0.jar

# fix cve-2024-13009
RUN mkdir /tmp/spark-core
RUN unzip /opt/spark/jars/spark-core_2.12-3.4.1.jar -d /tmp/spark-core/
RUN sed -i 's/9.4.50.v20221201/9.4.57.v20241219/g' /tmp/spark-core/META-INF/maven/org.eclipse.jetty/jetty-server/pom.*
RUN jar cf /opt/spark/jars/spark-core_2.12-3.4.1.jar -C /tmp/spark-core/ .
RUN rm -rf /tmp/spark-core/*

# fix GHSA-xpw8-rcwv-8f8p
RUN rm -f /opt/spark/jars/netty-*-4.1.87.Final*
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

# upgrade Python to 3.10
RUN apt-get purge --auto-remove -y python3.8 python3
RUN apt-get update && \
    apt install -y software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/nightly && \
    apt install -y python3.10 && \
    rm -rf /var/lib/apt/lists/*
RUN apt-get purge --auto-remove -y python3.8 python3
RUN ln -s python3.10 /usr/bin/python3 

RUN chown -R spark:spark /opt/spark

USER spark
