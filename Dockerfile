FROM openjdk:8-jre-alpine

# Alpine packages
RUN apk --no-cache add curl
RUN apk --no-cache add bash

# Dropwizard application connector port
EXPOSE 8080

# Dropwizard admin connector port
EXPOSE 8081

# Debugging Port
EXPOSE 8082

RUN ["mkdir", "-p", "/var/service/"]

# include dropwizard service jar and config
ADD ./config.yml /var/service/service-config.yml
ADD ./target/travis-poc.jar /var/service/

CMD [ \
  "java -jar", \
  "server", \
  "/var/service/service-config.yml"\
]
