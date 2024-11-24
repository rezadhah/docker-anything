#!/bin/bash

# Test Kafka Cluster Functionality
set -e  # Exit on any error

# Test cluster functionality
sleep 2
docker exec kafka-1 /usr/bin/kafka-broker-api-versions --bootstrap-server kafka-1:29092,kafka-2:29093,kafka-3:29094 > /dev/null
docker exec kafka-1 /usr/bin/kafka-topics --create --bootstrap-server kafka-1:29092 --topic test-topic --partitions 3 --replication-factor 3 > /dev/null

# Test message replication
echo "Test message 1" | docker exec -i kafka-1 /usr/bin/kafka-console-producer --bootstrap-server kafka-1:29092 --topic test-topic > /dev/null
echo "Test message 2" | docker exec -i kafka-2 /usr/bin/kafka-console-producer --bootstrap-server kafka-2:29093 --topic test-topic > /dev/null
echo "Test message 3" | docker exec -i kafka-3 /usr/bin/kafka-console-producer --bootstrap-server kafka-3:29094 --topic test-topic > /dev/null

# Verify messages
docker exec kafka-1 /usr/bin/kafka-console-consumer --bootstrap-server kafka-1:29092 --topic test-topic --from-beginning --max-messages 3 --timeout-ms 5000 > /dev/null

# Cleanup
docker exec kafka-1 /usr/bin/kafka-topics --delete --bootstrap-server kafka-1:29092 --topic test-topic > /dev/null

echo "Kafka cluster test: SUCCESS"
