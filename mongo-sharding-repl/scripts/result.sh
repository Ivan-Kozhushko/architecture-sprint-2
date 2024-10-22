#!/bin/bash

echo "Проверяем общее количество документов..."
result=$(docker exec -it mongos_router mongosh --port 27050 --quiet --eval '
use somedb
' --eval '
db.helloDoc.countDocuments();
')
echo "Всего документов в базе данных: $result"

echo "Проверяем количество документов на первом шарде(master)..."
result=$(docker exec -it shard1-0 mongosh --port 27040 --quiet --eval '
use somedb
' --eval '
db.helloDoc.countDocuments();
')
echo "Всего документов на первом шарде: $result"

echo "Проверяем количество документов на первом шарде(slave1)..."
result=$(docker exec -it shard1-1 mongosh --port 27041 --quiet --eval '
use somedb
' --eval '
db.helloDoc.countDocuments();
')
echo "Всего документов на первом шарде(slave1), должно быть столько же, сколько и в master: $result"

echo "Проверяем количество документов на первом шарде(slave2)..."
result=$(docker exec -it shard1-2 mongosh --port 27042 --quiet --eval '
use somedb
' --eval '
db.helloDoc.countDocuments();
')
echo "Всего документов на первом шарде(slave2), должно быть столько же, сколько и в master: $result"

echo "Проверяем количество документов на втором шарде..."
result=$(docker exec -it shard2-0 mongosh --port 27043 --quiet --eval '
use somedb
' --eval '
db.helloDoc.countDocuments();
')
echo "Всего документов на втором шарде: $result"

echo "Проверяем количество документов на втором шарде(slave1)..."
result=$(docker exec -it shard2-1 mongosh --port 27044 --quiet --eval '
use somedb
' --eval '
db.helloDoc.countDocuments();
')
echo "Всего документов на втором шарде(slave1), должно быть столько же, сколько и в master: $result"

echo "Проверяем количество документов на втором шарде(slave1)..."
result=$(docker exec -it shard2-2 mongosh --port 27045 --quiet --eval '
use somedb
' --eval '
db.helloDoc.countDocuments();
')
echo "Всего документов на втором шарде(slave1), должно быть столько же, сколько и в master: $result"