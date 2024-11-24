# Test Kafka Cluster Functionality
$ErrorActionPreference = "Stop"
try {
    Start-Sleep -Seconds 2

    # Test cluster functionality
    docker exec kafka-1 /usr/bin/kafka-broker-api-versions --bootstrap-server kafka-1:29092,kafka-2:29093,kafka-3:29094 > $null
    docker exec kafka-1 /usr/bin/kafka-topics --create --bootstrap-server kafka-1:29092 --topic test-topic --partitions 3 --replication-factor 3 > $null
    
    # Test message replication
    "Test message 1" | docker exec -i kafka-1 /usr/bin/kafka-console-producer --bootstrap-server kafka-1:29092 --topic test-topic > $null
    "Test message 2" | docker exec -i kafka-2 /usr/bin/kafka-console-producer --bootstrap-server kafka-2:29093 --topic test-topic > $null
    "Test message 3" | docker exec -i kafka-3 /usr/bin/kafka-console-producer --bootstrap-server kafka-3:29094 --topic test-topic > $null
    
    # Verify messages
    docker exec kafka-1 /usr/bin/kafka-console-consumer --bootstrap-server kafka-1:29092 --topic test-topic --from-beginning --max-messages 3 --timeout-ms 5000 > $null
    
    # Cleanup
    docker exec kafka-1 /usr/bin/kafka-topics --delete --bootstrap-server kafka-1:29092 --topic test-topic > $null
    
    Write-Host "Kafka cluster test: SUCCESS"
}
catch {
    Write-Host "Kafka cluster test: FAILED - $($_.Exception.Message)"
    exit 1
}