FROM openfalcon/makegcc-golang:1.10-alpine as builder
LABEL maintainer laiwei.ustc@gmail.com
USER root

ENV FALCON_DIR=/open-falcon PROJ_PATH=${GOPATH}/src/github.com/open-falcon/task

RUN mkdir -p $FALCON_DIR && \
    mkdir -p $FALCON_DIR/task/config && \
    mkdir -p $FALCON_DIR/task/bin && \
    mkdir -p $FALCON_DIR/task/var && \
    mkdir -p $PROJ_PATH && \
    apk add --no-cache ca-certificates bash git

COPY . ${PROJ_PATH}
WORKDIR ${PROJ_PATH}
RUN go get ./... && \
    ./control build  && \
    go build ./vendor/github.com/lxlee1102/cfgmaker && \
    cp -f falcon-task $FALCON_DIR/task/bin/falcon-task && \
    cp -f cfgmaker $FALCON_DIR/task/cfgmaker && \
    cp -f cmdocker/task.tpl $FALCON_DIR/task/ && \
    cp -f cmdocker/falcon-entry.sh $FALCON_DIR/ && \
    cp -f cmdocker/localtime.shanghai $FALCON_DIR/ && \
    rm -rf ${PROJ_PATH}


WORKDIR $FALCON_DIR
RUN tar -czf falcon-task.tar.gz ./


FROM harbor.cloudminds.com/library/alpine:3.CM-Beta-1.3
USER root

ENV PROJECT=mcs MODULE=falcon-task LOGPATH=

ENV FALCON_DIR=/open-falcon FALCON_MODULE=task

RUN mkdir -p $FALCON_DIR && \
    apk add --no-cache ca-certificates bash util-linux tcpdump busybox-extras

WORKDIR $FALCON_DIR

COPY --from=0  $FALCON_DIR/falcon-task.tar.gz  $FALCON_DIR/
COPY --from=0  $FALCON_DIR/localtime.shanghai  $FALCON_DIR/
RUN tar -zxf falcon-task.tar.gz && \
    rm -rf falcon-task.tar.gz && \
    mv localtime.shanghai /etc/localtime

EXPOSE 8010

# create config-files by ENV
CMD ["./falcon-entry.sh"]
