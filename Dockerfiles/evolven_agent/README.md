# EvolvenAgent Docker Image

Please include a copy of **evolvenAgent-7.2.2-19499.x86_64.rpm** in this directory to be used in the image.

## Building
```bash
docker build -t evolvenagent .
```

## Running
```bash
docker run --rm -ti --name evolvenagent -e agent.name.override=mydocker -e server.wsdl.url="https://host13.evolven.com/enlight.server/services/AgentService?wsdl" evolvenagent
```

