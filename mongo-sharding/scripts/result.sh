#!/bin/bash

echo "Проверяем общее количество документов..."
result=$(docker exec -it mongos_router mongosh --port 27020 --quiet --eval '
use somedb
' --eval '
db.helloDoc.countDocuments();
')
echo "Всего документов в базе данных: $result"

echo "Проверяем количество документов на первом шарде..."
result=$(docker exec -it shard1 mongosh --port 27018 --quiet --eval '
use somedb
' --eval '
db.helloDoc.countDocuments();
')
echo "Всего документов на первом шарде: $result"

echo "Проверяем количество документов на втором шарде..."
result=$(docker exec -it shard2 mongosh --port 27019 --quiet --eval '
use somedb
' --eval '
db.helloDoc.countDocuments();
')
echo "Всего документов на втором шарде: $result"