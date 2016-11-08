#!/bin/bash
Subnet="172.30.0.0/24"
Gateway="172.30.0.1"
Mysql_ip=172.30.0.15
Redis1_ip=172.30.0.16
Redis2_ip=172.30.0.17
Nginx_ip=172.30.0.10
Tomcat_api_ip=172.30.0.11
Tomcat_manager_ip=172.30.0.12
#Jenkins_ip=172.30.0.13
Rabbitmq_ip=172.30.0.14
Scheduler_ip=172.30.0.18
set -e
# create docker network
if [ -z "$(docker network ls|grep 'mynet' )" ];then
    docker network create --label mynet --subnet ${Subnet} --gateway ${Gateway} mynet
else
    echo 'Docker网络"mynet"已存在'
fi

# start mysql-data container
if [ -z "$(docker ps -a|grep 'mysql-data$' )" ];then
    docker run -h mysql-data --name=mysql-data -v /var/lib/mysql --net=mynet --storage-opt size=50G mysql:v1 true
else
    echo 'MySQL数据卷已存在'
fi

# start mysqld container
if [ -z "$(docker ps -a|grep 'mysql$' )" ];then
    docker run -h mysql --name=mysql -d -p 3306:3306 \
    --volumes-from=mysql-data --net=mynet --ip ${Mysql_ip} \
    -v /data/tmp:/data/tmp \
    -e MYSQL_ROOT_PASSWORD=123456 \
    -e MYSQL_DATABASE=niiwoo_test \
    -e MYSQL_DATABASE_LOG=niiwoo_log \
    -e MYSQL_USER=niiwoo \
    -e MYSQL_PASSWORD=123456 \
    mysql:v1
else 
    echo 'MySQL容器已存在'
fi

# start redis 1
if [ -z "$(docker ps -a|grep 'redis1$' )" ];then
    docker run -h redis1 --name=redis1 -d --net=mynet --ip ${Redis1_ip} redis:v1
else 
    echo 'redis1容器已存在'
fi

# start redis 2
if [ -z "$(docker ps -a|grep 'redis2$' )" ];then
    docker run -h redis2 --name=redis2 -d --net=mynet --ip ${Redis2_ip} redis:v1
else
    echo 'redis2容器已存在'
fi

# start rabbitmq
if [ -z "$(docker ps -a|grep 'rabbitmq$' )" ];then
    docker run -h rabbitmq --name=rabbitmq -d -e DEVEL_VHOST_NAME=niiwoo -p 15672:15672 --net=mynet --ip ${Rabbitmq_ip} rabbitmq:v1
else
    echo 'rabbitmq容器已存在'
fi

# start jenkins
#Jenkins_home=/data/jenkins_home
#if [ -z "$(docker ps -a|grep 'jenkins$' )" ];then
#    [ -d "${Jenkins_home}" ] || mkdir ${Jenkins_home}
#	chown -R 1000:1000 ${Jenkins_home}
#        setfacl -R -m d:u:1000:rwx ${Jenkins_home}
#    docker run -h jenkins --name=jenkins -d --net=mynet --ip ${Jenkins_ip} \
#    	-v ${Jenkins_home}:/var/jenkins_home \
#    	jenkins:v1
#    echo 'Jenkins容器已存在'
#fi

# start tomat-api
if [ -z "$(docker ps -a|grep 'tomcat_api$' )" ];then
    docker run -h tomcat-api --name=tomcat_api -d --net=mynet \
    --ip ${Tomcat_api_ip} -v /data/webapp1_log:/usr/local/tomcat/logs \
    -v /data/webapp1:/usr/local/tomcat/webapps \
    -v /data/imagedata:/data/imagedata \
    tomcat_api:v1
else
    echo 'tomcat-api容器已存在'
fi

# start tomat-manager
if [ -z "$(docker ps -a|grep 'tomcat_manager$' )" ];then
    docker run -h tomcat-manager --name=tomcat_manager -d --net=mynet \
    --ip ${Tomcat_manager_ip} -v /data/webapp2_log:/usr/local/tomcat/logs \
    -v /data/webapp2:/usr/local/tomcat/webapps \
    -v /data/imagedata:/data/imagedata \
    tomcat_manager:v1
else
    echo 'tomcat-manager容器已存在'
fi

# start scheduler
if [ -z "$(docker ps -a|grep 'scheduler$' )" ];then
    docker run -h scheduler --name=scheduler -d --net=mynet -v /data/webapp3:/app -v /data/webapp3_log:/var/log/scheduler --ip ${Scheduler_ip} scheduler:v1
else
    echo 'scheduler容器已存在'
fi

# start nginx
if [ -z "$(docker ps -a|grep 'nginx$' )" ];then
    docker run -h nginx --name=nginx -d --net=mynet -v /data/imagedata:/data/imagedata -p 80-83:80-83 --ip ${Nginx_ip} nginx:v1
else
    echo 'nginx容器已存在'
fi

