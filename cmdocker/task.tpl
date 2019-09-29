{
    "debug": false,
    "http": {
        "enable": true,
        "listen": "0.0.0.0:8010"
    },
    "index": {
        "enable": true,
        "dsn": "%%MYSQL%%/graph?loc=Local&parseTime=true",
        "maxIdle": 4,
        "autoDelete": false,
        "cluster":{
            %%TASK_GRAPH_CLUSTER%%
        }
    },
    "collector" : {
        "enable": true,
        "destUrl" : "%%PUSH_API%%",
        "srcUrlFmt" : "http://%s/statistics/all",
        "cluster" : [
            %%MODULES_HOST_PORT%%
        ]
    }
}
