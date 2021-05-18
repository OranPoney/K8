FROM centos:8

COPY evolvenAgent-7.2.2-19499.x86_64.rpm /tmp/evolvenAgent.rpm

RUN
    yum localinstall -y /tmp/evolvenAgent.rpm

CMD /opt/evolven_enlight/agent/bin/evwatchdog /opt/evolven_enlight/agent
