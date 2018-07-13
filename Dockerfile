FROM tomcat:8-alpine
LABEL LABEL maintainer="kaiser.andreas@gmail.com"

#Ports
EXPOSE 5200 5100
#ENV
ENV CODEBASE_URL file:/root/Protege_3.5/protege.jar
ENV EAM_VERSION 62

# Install some tools
RUN   apk update \
  &&   apk add ca-certificates wget graphviz \
  &&   update-ca-certificates

# Download essential project files and protege
RUN wget --tries=3 --progress=bar:force:noscroll https://enterprise-architecture.org/downloads_area/essentialinstall$EAM_VERSION.install \
  && wget --tries=3 --progress=bar:force:noscroll https://protege.stanford.edu/download/protege/3.5/installanywhere/Web_Installers/InstData/Linux/NoVM/install_protege_3.5.bin

# Copy auto install files to folder
COPY protege-response.txt auto-install.xml ./

# Install tools
RUN chmod u+x install_protege_3.5.bin \
  && ./install_protege_3.5.bin -i console -f protege-response.txt \
  && java -jar essentialinstall$EAM_VERSION.install auto-install.xml

RUN rm ./install_protege_3.5.bin

# Copy data & startup scripts
COPY server/* /opt/essentialAM/server/
COPY repo/* /opt/essentialAM/
COPY startup.sh run_protege_server_fix.sh /

#Some Java ENV
#RUN export JAVA_HOME=/usr/lib/jvm/default-jvm/jre/
ENV JAVA_HOME /usr/lib/jvm/default-jvm
WORKDIR /root/Protege_3.5/

#Prepare Filesystem & cleanup install files
RUN chmod +x /startup.sh  \
  && chmod +x /run_protege_server_fix.sh


# Startup the services
CMD ["/startup.sh"]
