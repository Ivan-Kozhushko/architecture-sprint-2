#!/bin/bash

echo "Инициализация config_server..."
result=$(docker exec -it configSrv mongosh --port 27030 --eval '
rs.initiate(
  {
    _id : "config_server",
       configsvr: true,
    members: [
      { _id : 0, host : "configSrv:27030" }
    ]
  }
);
')
echo "Результат инициализации config_server: $result"

echo "Инициализация shard1..."
result=$(docker exec -it shard1-0 mongosh --port 27040 --eval '
rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1-0:27040" },
        { _id : 1, host : "shard1-1:27041" },
        { _id : 2, host : "shard1-2:27042" }
      ]
    }
);
')
echo "Результат инициализации shard1-0: $result"

echo "Инициализация shard2..."
result=$(docker exec -it shard2-0 mongosh --port 27043 --eval '
rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 3, host : "shard2-0:27043" },
        { _id : 4, host : "shard2-1:27044" },
        { _id : 5, host : "shard2-2:27045" }
      ]
    }
  );
')
echo "Результат инициализации shard2: $result"

echo "Настройка базы данных и коллекции..."
result=$(docker exec -it mongos_router mongosh --port 27050 --eval '
sh.addShard( "shard1/shard1-0:27040,shard1-1:27041,shard1-2:27042");
sh.addShard( "shard2/shard2-0:27043,shard2-1:27044,shard2-2:27045");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
')
echo "Результат настройки базы данных и коллекции: $result"

echo "Наполнение данными..."
result=$(docker exec -it mongos_router mongosh --port 27050 --eval '
use somedb' --eval '
for(var i = 0; i < 2000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})
')
echo "Результат наполнения данными: $result"