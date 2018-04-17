FROM tomcat:8-alpine
LABEL LABEL maintainer="kaiser.andreas@gmail.com"

#Ports
EXPOSE 5200 5100
#ENV 
ENV CODEBASE_URL file:/root/Protege_3.5/protege.jar

# Install some tools
RUN   apk update \                                                                                                                                                                                                                        
  &&   apk add ca-certificates wget graphviz \                                                                                                                                                                                                      
  &&   update-ca-certificates    


# Download essential project files and protege
RUN wget --show-progress --quiet https://enterprise-architecture.org/downloads_area/essentialinstall611.install 
RUN wget --show-progress --quiet https://protege.stanford.edu/download/protege/3.5/installanywhere/Web_Installers/InstData/Linux/NoVM/install_protege_3.5.bin 

# Copy auto install files to folder
COPY protege-response.txt ./protege-response.txt 
COPY auto-install.xml ./auto-install.xml



# Install tools
RUN chmod u+x install_protege_3.5.bin
RUN ./install_protege_3.5.bin -i console -f protege-response.txt
RUN java -jar essentialinstall611.install auto-install.xml 

#Some Java ENV 
#RUN export JAVA_HOME=/usr/lib/jvm/default-jvm/jre/
ENV JAVA_HOME /usr/lib/jvm/default-jvm
WORKDIR /root/Protege_3.5/

# Copy data  
COPY data/* /data/
COPY repo/* /repo/ 
COPY startup.sh /startup.sh    
COPY run_protege_server.sh /run_protege_server_fix.sh  

#Prepare Filesystem
RUN chmod +x /startup.sh  \
  && chmod +x /run_protege_server_fix.sh 



# Startup the services 
CMD ["/startup.sh"]