FROM tomcat:8-alpine
LABEL LABEL maintainer="kaiser.andreas@gmail.com"
# Install some tools

 RUN   apk update \                                                                                                                                                                                                                        
  &&   apk add ca-certificates wget graphviz \                                                                                                                                                                                                      
  &&   update-ca-certificates    


# Download essential project
RUN wget https://enterprise-architecture.org/downloads_area/essentialinstall611.install
RUN wget https://protege.stanford.edu/download/protege/3.5/installanywhere/Web_Installers/InstData/Linux/NoVM/install_protege_3.5.bin
# Copy auto install files to folder

COPY protege-response.txt ./protege-response.txt 
COPY auto-install.xml ./auto-install.xml
#COPY install_protege_3.5.bin ./install_protege_3.5.bin


# Install tools
RUN chmod u+x install_protege_3.5.bin
RUN ./install_protege_3.5.bin -i console -f protege-response.txt
RUN java -jar essentialinstall611.install auto-install.xml 

RUN export JAVA_HOME=/usr/lib/jvm/default-jvm/jre/
ENV JAVA_HOME /usr/lib/jvm/default-jvm
WORKDIR /root/Protege_3.5/
#Fix
COPY run_protege_server.sh ./run_protege_server_fix.sh
#RUN
ENV CODEBASE_URL file:/root/Protege_3.5/protege.jar

EXPOSE 1099
COPY startup.sh /startservices.sh
RUN chmod +x /startservices.sh                                                                                                                                                                                                       
CMD ["/bin/bash" , "/startservices.sh"]