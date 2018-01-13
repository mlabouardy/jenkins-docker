FROM jenkins/jenkins:2.89.2
MAINTAINER mlabouardy <mohamed@labouardy.com>

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

USER root
RUN echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367  && \
    apt-get update && \
    apt-get install -y ansible

USER jenkins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

COPY jenkins.CLI.xml $JENKINS_HOME/jenkins.CLI.xml
COPY security.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy
COPY setup-credentials.groovy /usr/share/jenkins/ref/init.groovy.d/setup-credentials.groovy
