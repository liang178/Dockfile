#!/bin/bash
scheduler_home=/app/scheduler

[ -d /app ] || mkdir /app

if [ -d "${scheduler_home}" ];then
    cd ${scheduler_home}/bin && bash startJob.sh
fi

/usr/local/tomcat/bin/catalina.sh run
