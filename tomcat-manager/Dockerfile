FROM centos:v1
MAINTAINER      xin     'huangxiaoxin@tuandai.com'
#设置运行时的环境变量
ENV     CATALINA_HOME   /usr/local/tomcat
ENV     JAVA_HOME       /usr/local/jre
ENV     TZ=Asia/Shanghai
LABEL "test.niiwoo.com"="test tomcat-manager" "version"="1.0"

#设置镜像时间
RUN     ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
#复制jre、tomcat到容器中
COPY    jre1.7.0_79     /usr/local/jre
COPY    apache-tomcat-7.0.69    /usr/local/tomcat
COPY	setenv.sh	/usr/local/tomcat/bin/
COPY    *.xml	/usr/local/tomcat/conf/	
COPY	*.jar	/usr/local/tomcat/lib/
COPY	xml	/app/xml
EXPOSE  8080
ENTRYPOINT [ "/usr/local/tomcat/bin/catalina.sh","run" ]

