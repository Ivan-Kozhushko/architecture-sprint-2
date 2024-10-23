#!/bin/bash

echo "Инициализация config_server..."
result=$(docker exec -it configSrv mongosh --port 27017 --eval '
rs.initiate(
  {
    _id : "config_server",
       configsvr: true,
    members: [
      { _id : 0, host : "configSrv:27017" }
    ]
  }
);
')
echo "Результат инициализации config_server: $result"

echo "Инициализация shard1..."
result=$(docker exec -it shard1 mongosh --port 27018 --eval '
rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1:27018" },
      ]
    }
);
')
echo "Результат инициализации shard1: $result"

echo "Инициализация shard2..."
result=$(docker exec -it shard2 mongosh --port 27019 --eval '
rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 1, host : "shard2:27019" }
      ]
    }
  );
')
echo "Результат инициализации shard2: $result"

sleep 10

echo "Настройка базы данных и коллекции..."
result=$(docker exec -it mongos_router mongosh --port 27020 --eval '
sh.addShard( "shard1/shard1:27018");
sh.addShard( "shard2/shard2:27019");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
')
echo "Результат настройки базы данных и коллекции: $result"

echo "Наполнение данными..."
result=$(docker exec -it mongos_router mongosh --port 27020 --eval '
use somedb' --eval '
for(var i = 0; i < 2000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})
')
echo "Результат наполнения данными: $result"