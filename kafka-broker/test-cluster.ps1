# Test Kafka Cluster Functionality
Write-Host "Testing Kafka cluster..."

# Step 1: Verify all brokers are responding
# This checks if all 3 Kafka brokers are up and can respond to API requests
Write-Host "`nStep 1: Checking broker connectivity..."
docker exec kafka-1 /usr/bin/kafka-broker-api-versions --bootstrap-server kafka-1:29092,kafka-2:29093,kafka-3:29094

# Step 2: Create a topic with replication across the cluster
# Using replication-factor 3 ensures data is replicated to all brokers
Write-Host "`nStep 2: Creating replicated topic..."
docker exec kafka-1 /usr/bin/kafka-topics --create --bootstrap-server kafka-1:29092 --topic test-topic --partitions 3 --replication-factor 3

# Step 3: Verify topic configuration
# This shows partition distribution and replication status across brokers
Write-Host "`nStep 3: Verifying topic replication..."
docker exec kafka-1 /usr/bin/kafka-topics --describe --topic test-topic --bootstrap-server kafka-1:29092

# Step 4: Send test messages
# Sending multiple messages helps verify partition distribution
Write-Host "`nStep 4: Sending test messages..."
"Test message 1" | docker exec -i kafka-1 /usr/bin/kafka-console-producer --bootstrap-server kafka-1:29092 --topic test-topic
"Test message 2" | docker exec -i kafka-2 /usr/bin/kafka-console-producer --bootstrap-server kafka-2:29093 --topic test-topic
"Test message 3" | docker exec -i kafka-3 /usr/bin/kafka-console-producer --bootstrap-server kafka-3:29094 --topic test-topic

# Step 5: Read messages from different brokers
# Reading from different brokers verifies cluster-wide data availability
Write-Host "`nStep 5: Reading messages from different brokers..."
Write-Host "Reading from broker 1:"
docker exec kafka-1 /usr/bin/kafka-console-consumer --bootstrap-server kafka-1:29092 --topic test-topic --from-beginning --max-messages 3 --timeout-ms 5000

Write-Host "`nCluster test completed!"