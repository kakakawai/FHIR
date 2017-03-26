#!/bin/bash

while getopts "n:p:" opt; do
    case $opt in
        n)
            username=$OPTARG
            echo "[+]Username: $username"
            ;;
        p)
            serviceport=$OPTARG
            echo "[+]Service port: $serviceport"
            ;;
        \?)  
            echo "[+]Invalid option: -$OPTARG.Use -p (PORT) -n (NAME)."   
            ;;  
    esac
done


sudo apt-get update 
sudo apt-get upgrade

mkdir /usr/java

wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.tar.gz


tar zxvf ./jdk-8u121-linux-x64.tar.gz -C /usr/java

cp /root/.bashrc /root/.bashrc.beforeAddJDK.bak
echo 'JAVA_HOME=/usr/java/jdk1.8.0_121 #456' >> /root/.bashrc
echo 'JRE_HOME=$JAVA_HOME/jre' >> /root/.bashrc
echo 'JAVA_BIN=$JAVA_HOME/bin' >> /root/.bashrc
echo 'CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib' >> /root/.bashrc
echo 'PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin' >> /root/.bashrc
echo 'export JAVA_HOME JRE_HOME PATH CLASSPATH' >> /root/.bashrc
source /root/.bashrc

cp /etc/profile /etc/profile.beforeAddJDK.bak
echo 'JAVA_HOME=/usr/java/jdk1.8.0_121 #123' >> /etc/profile
echo 'JRE_HOME=$JAVA_HOME/jre' >> /etc/profile
echo 'JAVA_BIN=$JAVA_HOME/bin' >> /etc/profile
echo 'CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib' >> /etc/profile
echo 'PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin' >> /etc/profile
echo 'export JAVA_HOME JRE_HOME PATH CLASSPATH' >> /etc/profile
source /etc/profile

rm -rf /usr/bin/java
rm -rf /usr/bin/javac
rm -rf /usr/bin/jar
ln -s /usr/java/jdk1.8.0_121/bin/java /usr/bin/java
ln -s /usr/java/jdk1.8.0_121/bin/javac /usr/bin/javac
ln -s /usr/java/jdk1.8.0_121/bin/jar /usr/bin/jar

if [ -n "$(which java)" ]
then 
    echo ' '
    echo '[+]JDK 1.8.0_121 install success!'
    java -version
    echo ' '
else
    echo ' '
    echo '[+]JDK 1.8.0_121 install failure!'
    echo ' '
    exit
fi

wget http://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz

tar zxvf ./apache-maven-3.3.9-bin.tar.gz -C /usr/local

cp /root/.bashrc /root/.bashrc.beforeAddMaven.bak
echo 'export MVN_HOME=/usr/local/apache-maven-3.3.9' >> /root/.bashrc
echo 'export PATH=$MVN_HOME/bin:$PATH' >> /root/.bashrc
source /root/.bashrc

if [ -n "$username" ]
then
    echo "[++]$username"
    cp /home/$username/.bashrc /home/$username/.bashrc.beforeAddMaven.bak
    echo 'export MVN_HOME=/usr/local/apache-maven-3.3.9' >> /home/$username/.bashrc
    echo 'export PATH=$MVN_HOME/bin:$PATH' >> /home/$username/.bashrc
    source /home/$username/.bashrc
fi

cp /etc/profile /etc/profile.beforeAddMaven.bak
echo 'export MVN_HOME=/usr/local/apache-maven-3.3.9' >> /etc/profile
echo 'export PATH=$MVN_HOME/bin:$PATH' >> /etc/profile
source /etc/profile

rm -rf /usr/bin/mvn
ln -s /usr/local/apache-maven*/bin/mvn /usr/bin/mvn


if [ -n "$(which mvn)" ]
then 
    echo ' '
    echo '[+]Maven-3.3.9 install success!'
    mvn -v
    echo ' '
else
    echo ' '
    echo '[+]Maven-3.3.9 install failure!'
    echo ' '
    exit
fi

curl -fsSL https://get.docker.com/ | sh

#curl -sSL https://get.daocloud.io/docker | sh

if [ -n "$(which docker)" ]
then 
    echo ' '
    echo '[+]Docker install success!'
    docker -v
    echo ' '
else
    echo ' '
    echo '[+]Docker install failure!'
    echo ' '
    exit
fi

if [ -z "$serviceport" ]
then
    serviceport='8080'
fi

echo "[++]Server Port:$serviceport"
sudo bash ./deploy.sh -p $serviceport








