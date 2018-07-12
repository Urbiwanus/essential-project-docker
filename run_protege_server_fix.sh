#!/bin/sh

# ------------------- Where is Java? ------------------- 

# Change to the script' working directory, should be the Protege root directory 
#cd $(dirname $0)
echo "Starting Protege Server in "
pwd
DARWIN="false"

if [  -x /usr/bin/uname ]
then
  if [ "x`/usr/bin/uname`" = "xDarwin" ] 
  then
    DARWIN="true"
  fi
fi

if [ ${DARWIN} = "true" ]
then
  JAVA_PATH=/usr/bin
else 
  # Attempt to use the bundled VM if none specified
  if [ "$JAVA_HOME" = "" ]; then
	JAVA_HOME=.
  fi

  JAVA_PATH=$JAVA_HOME/jre/bin
fi

# Check if the Java VM can be found 
if [ ! -e $JAVA_PATH/java ]; then
	echo Java VM could not be found. Please check your JAVA_HOME environment variable.
	exit 1
fi
# ------------------- Where is Java? ------------------- 


CLASSPATH=protege.jar:looks.jar:driver.jar:driver0.jar:driver1.jar:driver2.jar
MAINCLASS=edu.stanford.smi.protege.server.Server


# ------------------- JVM Options ------------------- 
MAX_MEMORY=-Xmx500M
HEADLESS=-Djava.awt.headless=true
CODEBASE_URL=file:/root/Protege_3.5/protege.jar
CODEBASE=-Djava.rmi.server.codebase=$CODEBASE_URL
HOSTNAME_PARAM=-Djava.rmi.server.hostname=localhost
TX="-Dtransaction.level=READ_COMMITTED"
LOG4J_OPT="-Dlog4j.configuration=file:log4j.xml"

OPTIONS="$MAX_MEMORY $HEADLESS $CODEBASE $HOSTNAME_PARAM ${TX} ${LOG4J_OPT}"

#
# Instrumentation debug, delay simulation,  etc
#
PORTOPTS="-Dprotege.rmi.server.port=5200 -Dprotege.rmi.registry.port=5100"
#DEBUG_OPT="-Xdebug -Xrunjdwp:transport=dt_socket,address=8000,server=y,suspend=n"

OPTIONS="${OPTIONS} ${PORTOPTS} ${DEBUG_OPT}"
# ------------------- JVM Options ------------------- 

# ------------------- Cmd Options -------------------
# If you want automatic saving of the project, 
# setup the number of seconds in SAVE_INTERVAL_VALUE
# SAVE_INTERVAL=-saveIntervalSec=120
# ------------------- Cmd Options -------------------

METAPROJECT=/opt/essentialAM/server/metaproject.pprj

$JAVA_PATH/rmiregistry -J-Djava.class.path=$CLASSPATH 5100& 
$JAVA_PATH/java -cp $CLASSPATH $TX $OPTIONS $MAINCLASS $SAVE_INTERVAL $METAPROJECT
