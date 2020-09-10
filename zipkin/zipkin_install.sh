#!/bin/sh

# source:
# https://github.com/openzipkin/zipkin/issues/1870#issuecomment-470068636

# get normal zipkin server
curl -sSL https://zipkin.io/quickstart.sh | bash -s

# Write pom.xml thats responsible for generating eureka.jar
cat << 'EOF' > pom.xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>

  <groupId>io.zipkin.custom</groupId>
  <artifactId>eureka</artifactId>
  <version>1.0-SNAPSHOT</version>

  <description>Example module that adds Eureka to an existing Zipkin</description>

  <properties>
     <!-- make sure this matches zipkin-server's spring boot version -->
    <spring-boot.version>2.3.0.RELEASE</spring-boot.version>
  </properties>

  <dependencyManagement>
    <dependencies>
      <dependency>
        <!-- This makes sure versions are aligned properly -->
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-dependencies</artifactId>
        <version>${spring-boot.version}</version>
        <type>pom</type>
        <scope>import</scope>
      </dependency>
    </dependencies>
  </dependencyManagement>

  <dependencies>
    <!-- this is the thing that adds Eureka -->
    <dependency>
      <groupId>org.springframework.cloud</groupId>
      <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
      <version>2.2.2.RELEASE</version>
      <exclusions>
        <!-- zipkin already has this -->
        <exclusion>
          <groupId>org.springframework</groupId>
          <artifactId>*</artifactId>
        </exclusion>
        <exclusion>
          <groupId>org.springframework.boot</groupId>
          <artifactId>spring-boot-starter</artifactId>
        </exclusion>
      </exclusions>
    </dependency>

    <!-- -->
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-web</artifactId>
      <exclusions>
        <exclusion>
          <groupId>*</groupId>
          <artifactId>*</artifactId>
        </exclusion>
      </exclusions>
    </dependency>

  </dependencies>

  <build>
    <plugins>
      <plugin>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-maven-plugin</artifactId>
        <version>${spring-boot.version}</version>
        <executions>
          <execution>
            <goals>
              <goal>repackage</goal>
            </goals>
          </execution>
        </executions>
        <configuration>
          <layoutFactory implementation="zipkin.layout.ZipkinLayoutFactory">
            <name>zipkin</name>
          </layoutFactory>
          <classifier>module</classifier>
          <!-- exclude dependencies already packaged in zipkin-server. -->
          <!-- https://github.com/spring-projects/spring-boot/issues/3426 transitive exclude doesn't work -->
          <excludeGroupIds>io.zipkin.zipkin2,io.zipkin.reporter2,org.springframework.boot,com.fasterxml.jackson.core,com.google.auto.value,com.google.gson,com.google.guava,org.slf4j
          </excludeGroupIds>
        </configuration>
        <dependencies>
          <dependency>
            <groupId>io.zipkin.layout</groupId>
            <artifactId>zipkin-layout-factory</artifactId>
            <version>0.0.5</version>
          </dependency>
        </dependencies>
      </plugin>
    </plugins>
  </build>
</project>
EOF

# Build eureka module
mvn clean install

# Rename the jar so it is easier
mv target/eureka-1.0-SNAPSHOT-module.jar eureka.jar