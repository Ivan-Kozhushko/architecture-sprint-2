#!/bin/bash

echo "Инициализация config_server..."
result=$(docker exec -it configSrv mongosh --port 27051 --eval '
rs.initiate(
  {
    _id : "config_server",
       configsvr: true,
    members: [
      { _id : 0, host : "configSrv:27051" }
    ]
  }
);
')
echo "Результат инициализации config_server: $result"

echo "Инициализация shard1..."
result=$(docker exec -it shard1-0 mongosh --port 27052 --eval '
rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1-0:27052" },
        { _id : 1, host : "shard1-1:27053" },
        { _id : 2, host : "shard1-2:27054" }
      ]
    }
);
')
echo "Результат инициализации shard1-0: $result"

echo "Инициализация shard2..."
result=$(docker exec -it shard2-0 mongosh --port 27055 --eval '
rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 3, host : "shard2-0:27055" },
        { _id : 4, host : "shard2-1:27056" },
        { _id : 5, host : "shard2-2:27057" }
      ]
    }
  );
')
echo "Результат инициализации shard2: $result"
echo "Ждем 10 секунд, иначе ловим ошибку при попытке подлючиться к роутеру..."
sleep 10

echo "Настройка базы данных и коллекции..."
result=$(docker exec -it mongos_router mongosh --port 27060 --eval '
sh.addShard( "shard1/shard1-0:27052,shard1-1:27053,shard1-2:27054");
sh.addShard( "shard2/shard2-0:27055,shard2-1:27056,shard2-2:27057");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
')
echo "Результат настройки базы данных и коллекции: $result"

echo "Наполнение данными..."
result=$(docker exec -it mongos_router mongosh --port 27060 --eval '
use somedb' --eval '
for(var i = 0; i < 2000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})
')
echo "Результат наполнения данными: $result"