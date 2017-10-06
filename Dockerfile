FROM ubuntu:14.04
#MAINTAINER jerome.petazzoni@docker.com
# docker in docker with java installed
MAINTAINER anmaso@gmail.com

# Let's start with some basic stuff.
RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    lxc \
    iptables \
    software-properties-common && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt-get clean && \
    rm -rf /usr/lib/jvm/java-8-oracle/lib/missioncontrol && \
    rm -rf /usr/lib/jvm/java-8-oracle/lib/visualvm

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

    
# Install Docker from Docker Inc. repositories.
RUN curl -sSL https://get.docker.com/ | sh

# Install the magic wrapper.
ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

ADD http://public.dhe.ibm.com/cloud/bluemix/cli/bluemix-cli/latest/Bluemix_CLI_amd64.tar.gz ./bx.tar.gz

RUN tar -xvf bx.tar.gz
RUN Bluemix_CLI/install_bluemix_cli
RUN bx plugin install container-service -r Bluemix

# install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl 
RUN mv kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl

# Define additional metadata for our image.
VOLUME /var/lib/docker
CMD ["wrapdocker"]


