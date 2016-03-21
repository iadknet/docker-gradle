FROM java:8-jdk-alpine
MAINTAINER Isaac Stefanek <isaac@iadk.net>

# Gradle
ENV GRADLE_VERSION 2.5
ENV GRADLE_SHA 023e54fe656d87afab5c3014c6b7115f65ecb420b2e3135369286c36fcfc8d1f
VOLUME /tmp

ENV apk_packages_add curl unzip
ENV apk_packages_del curl unzip

RUN apk --update add ${apk_packages_add} \ 
 && cd /usr/lib \
 && curl -fl https://downloads.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -o gradle-bin.zip \
 && echo "$GRADLE_SHA  gradle-bin.zip" | sha256sum -c - \
 && unzip "gradle-bin.zip" \
 && ln -s "/usr/lib/gradle-${GRADLE_VERSION}/bin/gradle" /usr/bin/gradle \
 && rm "gradle-bin.zip" \
 && mkdir -p /usr/src/app \
 && apk del ${apk_packages_del}

# Set Appropriate Environmental Variables
ENV GRADLE_HOME /usr/lib/gradle
ENV PATH $PATH:$GRADLE_HOME/bin

# Caches
VOLUME ["/root/.gradle/caches", "/usr/bin/app"]

# Default command is "/usr/bin/gradle -version" on /usr/bin/app dir
# (ie. Mount project at /usr/bin/app "docker --rm -v /path/to/app:/usr/bin/app gradle <command>")
WORKDIR ["/usr/bin/app"]
ENTRYPOINT ["gradle"]
CMD ["-version"]
