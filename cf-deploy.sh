#!/bin/bash 
# ---------------------------------------------------------------------
# Assumes you are in the project directory:
# /Users/dqromney/projects/lds/demo-gateway
# ---------------------------------------------------------------------
# cf login -u romneydq
# ---------------------------------------------------------------------
cd /Users/dqromney/projects/lds/demo-gateway
# ---------------------------------------------------------------------
echo Building Configuration Server...
cd common/config-server
mvn clean package
cf push config-server -p target/config-server-1.war -m 512M
# ---------------------------------------------------------------------
echo Building Eureka Server...
cd ../eureka-server
mvn clean package
cf push eureka-server -p target/eureka-server-1.war -m 512M
# ---------------------------------------------------------------------
echo Building Subject Word server...
cd ../../word-server
mvn clean package -DjvmArguments=-Dspring.profiles.active=subject
cp target/word-server-1.war ./word-server-subject.war
# ---------------------------------------------------------------------
echo Building Verb Word server...
mvn clean package -DjvmArguments=-Dspring.profiles.active=verb
cp target/word-server-1.war ./word-server-verb.war
# ---------------------------------------------------------------------
echo Building Noun Word server...
mvn clean package -DjvmArguments=-Dspring.profiles.active=noun
cp target/word-server-1.war ./word-server-noun.war
# ---------------------------------------------------------------------
echo Building Adjective Word server...
mvn clean package -DjvmArguments=-Dspring.profiles.active=adjective
cp target/word-server-1.war ./word-server-adjective.war
# ---------------------------------------------------------------------
echo Building Article Word server...
mvn clean package -DjvmArguments=-Dspring.profiles.active=article
cp target/word-server-1.war ./word-server-article.war
# ---------------------------------------------------------------------
echo Deploying Word Servers to Cloud Foundry...
cf push word-server-subject -p word-server-subject.war -m 512M
cf push word-server-verb -p word-server-verb.war -m 512M
cf push word-server-noun -p word-server-noun.war -m 512M
cf push word-server-adjective -p word-server-adjective.war -m 512M
cf push word-server-article -p word-server-article.war -m 512M
# ---------------------------------------------------------------------
echo Building Gateway server...
cd ../gateway
mvn clean package
cf push gateway -p target/gateway-1.war -m 512M
cd /Users/dqromney/projects/lds/demo-gateway
cf apps
# ---------------------------------------------------------------------
#echo Building Gateway server...
#cf delete word-server-subject
#cf delete word-server-verb
#cf delete word-server-noun
#cf delete word-server-adjective
#cf delete word-server-article
#cf delete gateway
#cf delete eureka-server
#cf delete config-server
#cf apps
echo Finished!