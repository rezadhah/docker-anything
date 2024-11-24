# Local Kafka Setup with Docker Compose

This setup provides a local Kafka environment using Docker Compose, including:
- Apache Kafka (3 brokers)
- ZooKeeper

## Prerequisites
- Docker
- Docker Compose

## Getting Started

1. Start the Kafka cluster:
```bash
docker-compose up -d
```

2. To stop the cluster:
```bash
docker-compose down
```

Note: Data is persisted in Docker volumes. To completely remove the data and start fresh, use:
```bash
docker-compose down -v
```

## Configuration Details

### Broker Configuration
Each Kafka broker is configured with the following settings:

1. **Message Retention**
   - `KAFKA_LOG_RETENTION_HOURS`: 168 (7 days)
   - `KAFKA_LOG_SEGMENT_BYTES`: 1GB
   - `KAFKA_LOG_RETENTION_CHECK_INTERVAL_MS`: 300000 (5 minutes)

2. **Topic Configuration**
   - `KAFKA_AUTO_CREATE_TOPICS_ENABLE`: true
   - `KAFKA_NUM_PARTITIONS`: 3 (default partitions for new topics)
   - `KAFKA_DEFAULT_REPLICATION_FACTOR`: 3 (full replication across all brokers)
   - `KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR`: 3 (for internal topics)

3. **Networking**
   - Each broker has two listeners:
     - INSIDE: For inter-broker communication
     - OUTSIDE: For external client connections
   - Security protocol: PLAINTEXT (no encryption)

### Access Points
- ZooKeeper: `localhost:2181`
- Kafka Brokers:
  - Broker 1: `localhost:9092` (External) / `kafka-1:29092` (Internal)
  - Broker 2: `localhost:9093` (External) / `kafka-2:29093` (Internal)
  - Broker 3: `localhost:9094` (External) / `kafka-3:29094` (Internal)

### Data Persistence
The setup includes persistent volumes for both Kafka and ZooKeeper:
- ZooKeeper:
  - `zookeeper_data`: Stores ZooKeeper data
  - `zookeeper_log`: Stores ZooKeeper transaction logs
- Kafka:
  - `kafka_1_data`: Stores data for broker 1
  - `kafka_2_data`: Stores data for broker 2
  - `kafka_3_data`: Stores data for broker 3

## Testing the Setup

### Basic Topic Operations
1. Create a topic with replication:
```bash
docker exec kafka-1 kafka-topics --create --topic test-topic --bootstrap-server localhost:9092 --replication-factor 3 --partitions 3
```

2. List topics:
```bash
docker exec kafka-1 kafka-topics --list --bootstrap-server localhost:9092
```

3. Describe a topic:
```bash
docker exec kafka-1 kafka-topics --describe --topic test-topic --bootstrap-server localhost:9092
```

### Producer/Consumer Testing
1. Produce messages:
```bash
docker exec -i kafka-1 kafka-console-producer --bootstrap-server kafka-1:29092 --topic test-topic
```

2. Consume messages:
```bash
docker exec -i kafka-1 kafka-console-consumer --bootstrap-server kafka-1:29092 --topic test-topic --from-beginning
```

## Automated Testing
The repository includes automated test scripts for both Windows and Linux environments:

### Windows (PowerShell)
Run the PowerShell test script:
```powershell
.\test-cluster.ps1
```

### Linux (Bash)
Run the Bash test script:
```bash
chmod +x test-cluster.sh
./test-cluster.sh
```

These scripts automatically:
1. Verify cluster connectivity
2. Create a test topic with replication
3. Send messages through different brokers
4. Verify message replication
5. Clean up test resources

The scripts will output either "SUCCESS" or fail with an error message.

## Troubleshooting
1. Check container status:
```bash
docker ps
```

2. View logs:
```bash
# All containers
docker-compose logs -f

# Specific container
docker-compose logs -f kafka-1
```

3. Common issues:
   - Ensure ports 2181, 9092, 9093, and 9094 are not in use
   - Check ZooKeeper connectivity if brokers fail to start
   - Verify network connectivity between containers
   - Ensure sufficient disk space for log retention
