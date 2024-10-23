#!/bin/bash

echo "Проверяем общее количество документов..."
result=$(docker exec -it mongos_router mongosh --port 27060 --quiet --eval '
use somedb
' --eval '
db.helloDoc.countDocuments();
')
echo "Всего документов в базе данных: $result"

echo "Проверяем количество документов на первом шарде(master)..."
result=$(docker exec -it shard1-0 mongosh --port 27052 --quiet --eval '
use somedb
' --eval '
db.helloDoc.countDocuments();
')
echo "Всего документов на первом шарде: $result"

echo "Проверяем количество документов на первом шарде(slave1)..."
result=$(docker exec -it shard1-1 mongosh --port 27053 --quiet --eval '
use somedb
' --eval '
db.helloDoc.countDocuments();
')
echo "Всего документов на первом шарде(slave1), должно быть столько же, сколько и в master: $result"

echo "Проверяем количество документов на первом шарде(slave2)..."
result=$(docker exec -it shard1-2 mongosh --port 27054 --quiet --eval '
use somedb
' --eval '
db.helloDoc.countDocuments();
')
echo "Всего документов на первом шарде(slave2), должно быть столько же, сколько и в master: $result"

echo "Проверяем количество документов на втором шарде..."
result=$(docker exec -it shard2-0 mongosh --port 27055 --quiet --eval '
use somedb
' --eval '
db.helloDoc.countDocuments();
')
echo "Всего документов на втором шарде: $result"

echo "Проверяем количество документов на втором шарде(slave1)..."
result=$(docker exec -it shard2-1 mongosh --port 27056 --quiet --eval '
use somedb
' --eval '
db.helloDoc.countDocuments();
')
echo "Всего документов на втором шарде(slave1), должно быть столько же, сколько и в master: $result"

echo "Проверяем количество документов на втором шарде(slave1)..."
result=$(docker exec -it shard2-2 mongosh --port 27057 --quiet --eval '
use somedb
' --eval '
db.helloDoc.countDocuments();
')
echo "Всего документов на втором шарде(slave1), должно быть столько же, сколько и в master: $result"