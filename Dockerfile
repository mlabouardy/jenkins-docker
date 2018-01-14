FROM ubuntu:16.04
MAINTAINER mlabouardy <mohamed@labouardy.com>

ENV JENKINS_UC https://updates.jenkins.io
ENV JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental
ENV JENKINS_HOME /var/jenkins_home

RUN mkdir -p /usr/share/jenkins/ref

RUN apt-get update && apt-get install -y --no-install-recommends wget curl openssh-client git \
                      unzip apt-transport-https openjdk-8-jdk

RUN wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add -
RUN echo "deb https://pkg.jenkins.io/debian-stable binary/" >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y jenkins
RUN mkdir -p /var/jenkins_home && chown -R jenkins /var/jenkins_home

COPY jenkins-support /usr/local/bin/jenkins-support
COPY install-plugins.sh /usr/local/bin/plugins.sh
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/plugins.sh < /usr/share/jenkins/ref/plugins.txt
RUN mkdir -p $JENKINS_HOME/plugins
RUN mv /usr/share/jenkins/ref/plugins/* $JENKINS_HOME/plugins/

EXPOSE 8080 50000

COPY jenkins.CLI.xml $JENKINS_HOME/jenkins.CLI.xml
COPY init.groovy.d $JENKINS_HOME/init.groovy.d

CMD ["/usr/bin/java", "-Djenkins.install.runSetupWizard=false", "-jar", "/usr/share/jenkins/jenkins.war"]
