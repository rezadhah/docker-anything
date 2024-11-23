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

## Configuration Details
- ZooKeeper is accessible at `localhost:2181`
- Kafka Brokers are accessible at:
  - Broker 1: `localhost:9092`
  - Broker 2: `localhost:9093`
  - Broker 3: `localhost:9094`

## Testing the Setup
You can test if Kafka is working by:
1. Creating a topic with replication:
```bash
docker exec kafka-1 kafka-topics --create --topic test-topic --bootstrap-server localhost:9092 --replication-factor 3 --partitions 3
```

2. List topics:
```bash
docker exec kafka-1 kafka-topics --list --bootstrap-server localhost:9092
```

3. Describe the topic to verify replication:
```bash
docker exec kafka-1 kafka-topics --describe --topic test-topic --bootstrap-server localhost:9092
```

## Troubleshooting
If you encounter issues:
1. Check if containers are running: `docker ps`
2. View logs: `docker-compose logs -f`
3. Ensure ports 2181, 9092, 9093, and 9094 are not in use by other services
