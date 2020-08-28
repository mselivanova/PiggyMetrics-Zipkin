FROM java:8-jre
MAINTAINER Maria Selivanova <maria@selivanova.com>

ADD ./eureka.jar /eureka.jar
ADD ./zipkin.jar /zipkin.jar
#CMD ["java", "-Xmx200m", "-Dloader.path=eureka.jar,eureka.jar!/lib", "-Dspring.boot.enableautoconfiguration=true", "-Dspring.application.name=zipkin-server", "-cp", "/zipkin.jar", "org.springframework.boot.loader.PropertiesLauncher"]
CMD ["java", "-Xmx200m", "-Dloader.path=eureka.jar,eureka.jar!/lib", "-Dspring.boot.enableautoconfiguration=true", "-Deureka.client.serviceUrl.defaultZone=http://registry:8761/eureka", "-Dspring.application.name=zipkin", "-cp", "/zipkin.jar", "org.springframework.boot.loader.PropertiesLauncher"]

EXPOSE 9411