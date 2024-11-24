# Test Kafka cluster
Write-Host "Testing Kafka cluster..."

# Create topic
Write-Host "Creating topic..."
docker exec kafka-1 /usr/bin/kafka-topics --create --bootstrap-server kafka-1:29092 --topic test-topic --partitions 1 --replication-factor 1

# Send message
Write-Host "Sending message..."
"Test message" | docker exec -i kafka-1 /usr/bin/kafka-console-producer --bootstrap-server kafka-1:29092 --topic test-topic

# Read message
Write-Host "Reading message..."
docker exec kafka-1 /usr/bin/kafka-console-consumer --bootstrap-server kafka-1:29092 --topic test-topic --from-beginning --max-messages 1