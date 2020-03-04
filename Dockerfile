FROM centos:centos6

MAINTAINER test.com

# Install MongoDB
# creating repo file in /etc/yum.repos.d
RUN echo -e "[mongodb]\nname=MongoDB Repository\nbaseurl=http://downloads-distro.mongodb.org/repo/redhat/os/`uname -m`/\ngpgcheck=0\nenabled=1" > /etc/yum.repos.d/mongodb.repo
RUN yum update -y
RUN yum install mongo-10gen mongo-10gen-server -y
RUN yum clean all

# Install yum dependencies
# && == if the first command succeeded, run the next one
# Example command:  true && echo "Things went well" output will be Things went well

# \ == the next line is part of the first line, not two seperate lines
#"\" by itself at the end of a line is a means of concatenating lines together So the following two lines:
# yum install -y \ and bzip2-devel \ are exactly on same line

RUN yum -y update && \
    yum groupinstall -y development && \
    yum install -y \
    bzip2-devel \
    git \
    hostname \
    openssl \
    openssl-devel \
    sqlite-devel \
    sudo \
    tar \
    wget \
    zlib-dev

# Install python2.7
#The --prefix=PREFIX option installs architecture independent files in PREFIX.
# When you run a make install command, libraries will be placed in the PREFIX/lib directory, executables in the PREFIX/bin directory and so on.
#If this argument is not passed to the configure command then the default value is /usr/local,so to avoid problem prefix used

RUN cd /tmp && \
    wget https://www.python.org/ftp/python/2.7.8/Python-2.7.8.tgz && \
    tar xvfz Python-2.7.8.tgz && \
    cd Python-2.7.8 && \
    ./configure --prefix=/usr/local && \
    make && \
    make altinstall


# Download JDK
#RUN cd /opt;wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u55-b13/jdk-7u55-linux-x64.tar.gz; pwd

#oracle urls were not working hence had to use java index since java 7 are decpreciated
RUN cd /opt && \
    wget http://app.nidc.kr/java/jdk-7u79-linux-x64.tar.gz && \
    tar xvf jdk-7u79-linux-x64.tar.gz

RUN alternatives --install /usr/bin/java java /opt/jdk1.7.0_79/bin/java 2

# Download Apache Tomcat 7
# untar and move to proper location
RUN cd /tmp && \
    wget http://www-eu.apache.org/dist/tomcat/tomcat-7/v7.0.82/bin/apache-tomcat-7.0.82.tar.gz && \
    tar xvf apache-tomcat-7.0.82.tar.gz

RUN cd /tmp;mv apache-tomcat-7.0.82 /opt/tomcat7

RUN chmod -R 755 /opt/tomcat7

# Set Java Home path
ENV JAVA_HOME /opt/jdk1.7.0_79
#ENV PATH $PATH:$JAVA_HOME/bin:/opt/tomcat/bin

#default port for tomcat
EXPOSE 8080

#WORKDIR /opt/tomcat7/bin
#command to start tomcat
#CMD ["catalina.sh", "run"]
CMD /opt/tomcat7/bin/catalina.sh run



# Use docker file to build image
#Run the Docker build command to build the Docker file.  It can be done using the following command
# -t, --tag=Repository name (and optionally a tag) for the image

#pre -requisite yum install docker-io(install docker file)
#mkdir DockerFile;cd DockerFile; place your docker fil here and run below command
#docker image build -t test.com/centos6:wevserver .(docker file path)


#it’s now time to create a container from the image. We can do this with the Docker run command.

# -i, --interactive=false     Keep STDIN open even if not attached
# -t, --tty=false             Allocate a pseudo-TTY
# -p, --publish=[]            Publish a container's port(s) to the host(binding container port to host ip)
# -d, --detach=false          Run container in background and print container ID
#sudo docker container run -d -p 7080:8080 -t -i test.com/centos6:webserver

