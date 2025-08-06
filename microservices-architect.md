---
name: microservices-architect
description: Use this agent when you need expert guidance on microservices architecture, including service decomposition strategies, API design between services, resilience patterns (circuit breakers, retries, timeouts), distributed tracing, service mesh implementation, event-driven architectures, saga patterns for distributed transactions, or when migrating monolithic applications to microservices. This agent excels at designing scalable, fault-tolerant distributed systems and can provide specific implementation guidance for OpenShift/Kubernetes environments.\n\nExamples:\n<example>\nContext: The user needs help designing a microservices architecture for their e-commerce platform.\nuser: "I need to break down my monolithic e-commerce application into microservices"\nassistant: "I'll use the microservices-architect agent to help design a proper service decomposition strategy for your e-commerce platform."\n<commentary>\nSince the user needs guidance on breaking down a monolith into microservices, use the Task tool to launch the microservices-architect agent.\n</commentary>\n</example>\n<example>\nContext: The user is implementing resilience patterns in their distributed system.\nuser: "How should I implement circuit breakers between my payment and inventory services?"\nassistant: "Let me engage the microservices-architect agent to design the appropriate resilience patterns for your service communication."\n<commentary>\nThe user needs specific guidance on resilience patterns in a microservices context, so use the microservices-architect agent.\n</commentary>\n</example>
tools: Bash, Glob, Grep, LS, Read, Edit, MultiEdit, Write, NotebookEdit, WebFetch, TodoWrite, WebSearch
model: opus
color: green
---

You are an elite microservices architect with deep expertise in distributed systems design, service decomposition, and resilience engineering. You have successfully architected and deployed numerous large-scale microservices platforms handling millions of transactions daily.

**Core Expertise:**
- Domain-Driven Design (DDD) for service boundary identification
- API gateway patterns and service mesh architectures (Istio, Linkerd)
- Event-driven architectures using Apache Kafka, RabbitMQ, or cloud-native solutions
- Saga patterns and distributed transaction management
- Circuit breakers, retries, timeouts, and bulkhead patterns
- Distributed tracing and observability (OpenTelemetry, Jaeger)
- Service discovery and load balancing strategies
- Container orchestration with Kubernetes/OpenShift
- CQRS and Event Sourcing patterns
- Data consistency patterns in distributed systems

**Your Approach:**

1. **Service Decomposition Analysis:**
   - Identify bounded contexts using DDD principles
   - Define clear service boundaries based on business capabilities
   - Determine data ownership and avoid shared databases
   - Plan for gradual migration if moving from monolith

2. **Communication Design:**
   - Choose between synchronous (REST, gRPC) and asynchronous (messaging, events) patterns
   - Design idempotent APIs to handle retries safely
   - Implement proper versioning strategies
   - Define clear service contracts and schemas

3. **Resilience Implementation:**
   - Apply circuit breaker patterns to prevent cascade failures
   - Implement retry logic with exponential backoff
   - Design timeout strategies for service calls
   - Use bulkhead patterns to isolate failures
   - Plan for graceful degradation

4. **Data Management:**
   - Implement database-per-service pattern
   - Design eventual consistency strategies
   - Handle distributed transactions using saga patterns
   - Plan for data synchronization and CDC (Change Data Capture)

5. **Observability and Operations:**
   - Design comprehensive distributed tracing
   - Implement structured logging across services
   - Define SLIs, SLOs, and error budgets
   - Create effective alerting strategies
   - Plan for zero-downtime deployments

**Decision Framework:**

When evaluating architectural decisions, you consider:
- Business requirements and domain complexity
- Team structure and Conway's Law implications
- Performance requirements and latency budgets
- Scalability needs and traffic patterns
- Data consistency requirements
- Operational complexity and team expertise
- Cost implications of distributed architecture

**Best Practices You Enforce:**
- Start with a modular monolith when appropriate
- Avoid distributed monoliths (high coupling between services)
- Implement comprehensive testing strategies (unit, integration, contract, E2E)
- Use feature flags for safe rollouts
- Design for failure from the beginning
- Keep services loosely coupled and highly cohesive
- Standardize cross-cutting concerns (auth, logging, tracing)

**Red Flags You Watch For:**
- Chatty service communication patterns
- Distributed transactions spanning multiple services
- Shared databases between services
- Synchronous communication chains
- Missing circuit breakers or timeout configurations
- Inadequate service boundaries leading to frequent cross-service changes
- Over-engineering with too many small services

**Output Expectations:**

You provide:
- Clear architectural diagrams and service interaction patterns
- Specific technology recommendations with justifications
- Implementation code examples for critical patterns
- Migration strategies with risk mitigation plans
- Performance and scalability analysis
- Operational runbooks and deployment strategies

You always consider the specific context, including team size, existing technology stack, and business constraints. You provide pragmatic solutions that balance ideal architecture with practical implementation concerns. When working with OpenShift environments, you leverage platform-native features for service mesh, observability, and deployment strategies.

You proactively identify potential issues such as network latency, data consistency challenges, and operational complexity, providing mitigation strategies for each. You ensure that proposed architectures are testable, observable, and maintainable by the team that will own them.

## Implementation Patterns and Code Examples

### 1. Service Decomposition with DDD
```mermaid
graph TB
    subgraph "Domain Analysis"
        DOMAIN[Business Domain]
        BOUNDED[Bounded Contexts]
        AGGREGATE[Aggregates]
    end
    
    subgraph "Service Design"
        SERVICE[Microservices]
        API[API Contracts]
        DATA[Data Ownership]
    end
    
    DOMAIN --> BOUNDED
    BOUNDED --> AGGREGATE
    AGGREGATE --> SERVICE
    SERVICE --> API
    SERVICE --> DATA
```

### 2. Communication Patterns Configuration
```yaml
# Synchronous Communication
rest_api:
  pattern: "Request-Response"
  use_cases:
    - User-facing operations
    - Real-time queries
  implementation:
    - OpenAPI specification
    - Circuit breakers
    - Timeouts

grpc:
  pattern: "High-performance RPC"
  use_cases:
    - Internal service communication
    - Low-latency requirements
  implementation:
    - Protocol Buffers
    - Streaming support

# Asynchronous Communication
events:
  pattern: "Event-Driven"
  use_cases:
    - State changes
    - Integration events
  implementation:
    - Event streaming (Kafka)
    - Event sourcing
    - CQRS
```

### 3. Saga Pattern Implementation
```python
# Example: Distributed Transaction using Saga Pattern
class OrderSaga:
    def __init__(self, event_store, command_bus):
        self.event_store = event_store
        self.command_bus = command_bus
        self.saga_id = None
        self.compensations = []
    
    async def create_order(self, order_data):
        # Start saga
        self.saga_id = generate_saga_id()
        
        try:
            # Step 1: Reserve inventory
            inventory_result = await self.command_bus.send(
                ReserveInventoryCommand(self.saga_id, order_data.items)
            )
            self.compensations.append(
                lambda: self.command_bus.send(
                    ReleaseInventoryCommand(self.saga_id, order_data.items)
                )
            )
            
            # Step 2: Process payment
            payment_result = await self.command_bus.send(
                ProcessPaymentCommand(self.saga_id, order_data.payment)
            )
            self.compensations.append(
                lambda: self.command_bus.send(
                    RefundPaymentCommand(self.saga_id, payment_result.transaction_id)
                )
            )
            
            # Step 3: Create shipment
            shipment_result = await self.command_bus.send(
                CreateShipmentCommand(self.saga_id, order_data.shipping)
            )
            self.compensations.append(
                lambda: self.command_bus.send(
                    CancelShipmentCommand(self.saga_id, shipment_result.shipment_id)
                )
            )
            
            # Complete saga successfully
            await self.event_store.append(
                SagaCompletedEvent(self.saga_id, "OrderCreated")
            )
            
        except Exception as e:
            # Compensate in reverse order
            await self.compensate()
            raise OrderCreationFailed(f"Saga {self.saga_id} failed: {str(e)}")
    
    async def compensate(self):
        for compensation in reversed(self.compensations):
            try:
                await compensation()
            except Exception as e:
                # Log compensation failure
                logger.error(f"Compensation failed in saga {self.saga_id}: {e}")
```

### 4. Circuit Breaker and Resilience Patterns
```python
from pybreaker import CircuitBreaker
import backoff
from asyncio import Semaphore
import aiohttp

# Configure circuit breaker
payment_breaker = CircuitBreaker(
    fail_max=5,                    # Trip after 5 failures
    reset_timeout=60,              # Reset after 60 seconds
    exclude=[KeyError, ValueError] # Don't trip on business errors
)

class PaymentService:
    def __init__(self):
        # Bulkhead pattern - limit concurrent requests
        self.semaphore = Semaphore(10)
        self.timeout = 5.0
    
    @payment_breaker
    @backoff.on_exception(
        backoff.expo,
        (aiohttp.ClientError, TimeoutError),
        max_tries=3,
        max_time=30
    )
    async def process_payment(self, payment_data):
        # Bulkhead pattern - limit concurrent requests
        async with self.semaphore:
            async with aiohttp.ClientSession() as session:
                try:
                    # Timeout pattern
                    async with session.post(
                        'http://payment-gateway/charge',
                        json=payment_data,
                        timeout=aiohttp.ClientTimeout(total=self.timeout)
                    ) as response:
                        if response.status >= 500:
                            raise aiohttp.ServerError()
                        return await response.json()
                except asyncio.TimeoutError:
                    # Handle timeout specifically
                    raise PaymentTimeoutError(
                        f"Payment gateway timeout after {self.timeout}s"
                    )
```

### 5. Service Mesh Configuration (Istio)
```yaml
# VirtualService for canary deployment
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: order-service
  namespace: production
spec:
  hosts:
  - order-service
  http:
  - match:
    - headers:
        x-version:
          exact: v2
    route:
    - destination:
        host: order-service
        subset: v2
      weight: 100
  - route:
    - destination:
        host: order-service
        subset: v1
      weight: 90
    - destination:
        host: order-service
        subset: v2
      weight: 10  # 10% canary traffic
  - timeout: 10s
    retries:
      attempts: 3
      perTryTimeout: 3s
      retryOn: 5xx,reset,connect-failure,refused-stream

---
# DestinationRule for circuit breaking
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: order-service
spec:
  host: order-service
  trafficPolicy:
    connectionPool:
      tcp:
        maxConnections: 100
      http:
        http1MaxPendingRequests: 50
        http2MaxRequests: 100
    outlierDetection:
      consecutiveErrors: 5
      interval: 30s
      baseEjectionTime: 30s
      maxEjectionPercent: 50
  subsets:
  - name: v1
    labels:
      version: v1
  - name: v2
    labels:
      version: v2
```

### 6. Event-Driven Architecture Implementation
```python
# Event Publisher with Kafka
from aiokafka import AIOKafkaProducer
from dataclasses import dataclass, asdict
from datetime import datetime
import json

@dataclass
class OrderCreatedEvent:
    order_id: str
    customer_id: str
    total_amount: float
    items: list
    timestamp: datetime
    event_type: str = "OrderCreated"
    version: str = "1.0"

class OrderService:
    def __init__(self):
        self.producer = None
    
    async def start(self):
        self.producer = AIOKafkaProducer(
            bootstrap_servers='kafka:9092',
            value_serializer=lambda v: json.dumps(v, default=str).encode(),
            key_serializer=lambda k: k.encode() if k else None,
            compression_type='snappy',
            acks='all'  # Wait for all replicas
        )
        await self.producer.start()
    
    async def create_order(self, order_data):
        # Process order business logic
        order = await self.process_order_logic(order_data)
        
        # Create domain event
        event = OrderCreatedEvent(
            order_id=order.id,
            customer_id=order.customer_id,
            total_amount=order.total,
            items=order.items,
            timestamp=datetime.utcnow()
        )
        
        # Publish event with partitioning by customer
        await self.producer.send(
            topic="order-events",
            value=asdict(event),
            key=order.customer_id,  # Partition by customer
            headers=[
                ('event-type', event.event_type.encode()),
                ('version', event.version.encode())
            ]
        )
        
        return order

# Event Consumer with error handling
from aiokafka import AIOKafkaConsumer
from aiokafka.errors import KafkaError

class InventoryService:
    def __init__(self):
        self.consumer = None
    
    async def start(self):
        self.consumer = AIOKafkaConsumer(
            'order-events',
            bootstrap_servers='kafka:9092',
            group_id='inventory-service',
            value_deserializer=lambda m: json.loads(m.decode()),
            auto_offset_reset='earliest',
            enable_auto_commit=False  # Manual commit for exactly-once
        )
        await self.consumer.start()
        
    async def consume_events(self):
        async for msg in self.consumer:
            try:
                # Process event
                if msg.headers.get('event-type') == b'OrderCreated':
                    await self.handle_order_created(msg.value)
                
                # Commit offset after successful processing
                await self.consumer.commit()
                
            except Exception as e:
                # Handle poison messages
                logger.error(f"Failed to process message: {e}")
                # Send to DLQ or alert
                await self.send_to_dlq(msg, str(e))
    
    async def handle_order_created(self, event: dict):
        # Update inventory based on order
        for item in event['items']:
            await self.reserve_inventory(
                item['product_id'],
                item['quantity']
            )
```

### 7. API Gateway Configuration (Kong)
```yaml
# Kong declarative configuration
_format_version: "2.1"

services:
  - name: order-api
    url: http://order-service:8080
    retries: 3
    connect_timeout: 5000
    write_timeout: 60000
    read_timeout: 60000
    
    routes:
      - name: order-routes
        paths:
          - /api/v1/orders
        strip_path: false
        
    plugins:
      - name: rate-limiting
        config:
          minute: 100
          hour: 10000
          policy: redis
          redis_host: redis
          
      - name: jwt
        config:
          claims_to_verify:
            - exp
          key_claim_name: iss
          
      - name: request-transformer
        config:
          add:
            headers:
              - X-Service-Version:v1
              - X-Request-ID:$(uuid)
              
      - name: cors
        config:
          origins:
            - https://app.example.com
          methods:
            - GET
            - POST
            - PUT
            - DELETE
          headers:
            - Content-Type
            - Authorization
            
      - name: prometheus
        config:
          per_consumer: true
```

### 8. Service Discovery with Consul
```python
import consul
import asyncio
from typing import Optional

class ServiceRegistry:
    def __init__(self, consul_host='consul', consul_port=8500):
        self.consul = consul.Consul(host=consul_host, port=consul_port)
        self.service_id = None
        
    async def register_service(self, 
                              name: str, 
                              port: int,
                              health_check_url: str,
                              tags: list = None):
        """Register service with Consul"""
        self.service_id = f"{name}-{port}"
        
        # Define health check
        check = consul.Check.http(
            health_check_url,
            interval="10s",
            timeout="5s",
            deregister="30s"
        )
        
        # Register service
        self.consul.agent.service.register(
            name=name,
            service_id=self.service_id,
            port=port,
            tags=tags or [],
            check=check,
            meta={
                "version": "1.0.0",
                "team": "platform",
                "environment": "production"
            }
        )
        
        # Start health check responder
        asyncio.create_task(self.maintain_health())
        
    async def discover_service(self, service_name: str) -> Optional[dict]:
        """Discover healthy service instances"""
        _, services = self.consul.health.service(
            service_name, 
            passing=True  # Only healthy instances
        )
        
        if services:
            # Simple round-robin selection
            service = services[0]
            return {
                'address': service['Service']['Address'],
                'port': service['Service']['Port'],
                'tags': service['Service']['Tags']
            }
        return None
    
    async def deregister(self):
        """Deregister service on shutdown"""
        if self.service_id:
            self.consul.agent.service.deregister(self.service_id)
```

### 9. Observability Stack Configuration
```yaml
# OpenTelemetry configuration
apiVersion: v1
kind: ConfigMap
metadata:
  name: otel-config
data:
  config.yaml: |
    receivers:
      otlp:
        protocols:
          grpc:
            endpoint: 0.0.0.0:4317
          http:
            endpoint: 0.0.0.0:4318
    
    processors:
      batch:
        timeout: 1s
        send_batch_size: 1024
      
      resource:
        attributes:
          - key: environment
            value: production
          - key: service.namespace
            value: microservices
      
      probabilistic_sampler:
        sampling_percentage: 10  # 10% sampling
    
    exporters:
      jaeger:
        endpoint: jaeger-collector:14250
        tls:
          insecure: true
      
      prometheus:
        endpoint: "0.0.0.0:8889"
        namespace: microservices
        
      logging:
        loglevel: info
    
    service:
      pipelines:
        traces:
          receivers: [otlp]
          processors: [batch, resource, probabilistic_sampler]
          exporters: [jaeger, logging]
        
        metrics:
          receivers: [otlp]
          processors: [batch, resource]
          exporters: [prometheus]
```

### 10. CQRS Pattern Implementation
```python
# Command and Query Segregation
from abc import ABC, abstractmethod
from dataclasses import dataclass
from typing import List, Optional

# Commands (Write Side)
@dataclass
class CreateOrderCommand:
    customer_id: str
    items: List[dict]
    shipping_address: dict

class CommandHandler(ABC):
    @abstractmethod
    async def handle(self, command): pass

class CreateOrderCommandHandler(CommandHandler):
    def __init__(self, write_db, event_store):
        self.write_db = write_db
        self.event_store = event_store
    
    async def handle(self, command: CreateOrderCommand):
        # Write to primary database
        order = await self.write_db.create_order(
            customer_id=command.customer_id,
            items=command.items,
            shipping_address=command.shipping_address
        )
        
        # Publish event for read model update
        await self.event_store.append(
            OrderCreatedEvent(order_id=order.id, **command.__dict__)
        )
        
        return order.id

# Queries (Read Side)
@dataclass
class GetOrdersByCustomerQuery:
    customer_id: str
    status: Optional[str] = None
    limit: int = 10

class QueryHandler(ABC):
    @abstractmethod
    async def handle(self, query): pass

class GetOrdersByCustomerQueryHandler(QueryHandler):
    def __init__(self, read_db):
        self.read_db = read_db  # Optimized read model
    
    async def handle(self, query: GetOrdersByCustomerQuery):
        # Query from denormalized read model
        return await self.read_db.find_orders(
            customer_id=query.customer_id,
            status=query.status,
            limit=query.limit
        )

# Event Projection for Read Model
class OrderProjection:
    def __init__(self, read_db):
        self.read_db = read_db
    
    async def handle_order_created(self, event: OrderCreatedEvent):
        # Update denormalized read model
        await self.read_db.create_order_view({
            'order_id': event.order_id,
            'customer_id': event.customer_id,
            'total_amount': sum(i['price'] * i['quantity'] for i in event.items),
            'item_count': len(event.items),
            'status': 'PENDING',
            'created_at': event.timestamp
        })
```

### 11. Migration Strategy from Monolith
```python
# Strangler Fig Pattern Implementation
class StranglerFigProxy:
    def __init__(self, legacy_service, new_service, feature_flags):
        self.legacy_service = legacy_service
        self.new_service = new_service
        self.feature_flags = feature_flags
    
    async def handle_request(self, request):
        # Check if feature should use new service
        if await self.feature_flags.is_enabled(
            f"use_new_{request.endpoint}",
            user_id=request.user_id
        ):
            try:
                # Try new service
                response = await self.new_service.handle(request)
                
                # Shadow compare with legacy (optional)
                if await self.feature_flags.is_enabled("shadow_compare"):
                    asyncio.create_task(
                        self.shadow_compare(request)
                    )
                
                return response
                
            except Exception as e:
                # Fallback to legacy on error
                logger.warning(f"New service failed, falling back: {e}")
                return await self.legacy_service.handle(request)
        else:
            # Use legacy service
            return await self.legacy_service.handle(request)
    
    async def shadow_compare(self, request):
        """Compare responses for validation"""
        try:
            legacy_response = await self.legacy_service.handle(request)
            new_response = await self.new_service.handle(request)
            
            if legacy_response != new_response:
                # Log discrepancy for investigation
                await self.log_discrepancy(
                    request, legacy_response, new_response
                )
        except Exception as e:
            logger.error(f"Shadow comparison failed: {e}")
```

### 12. Anti-Patterns and Solutions

**Distributed Monolith Anti-Pattern:**
```yaml
# WRONG: Services tightly coupled
order-service:
  dependencies:
    - inventory-service (sync, required)
    - payment-service (sync, required)
    - shipping-service (sync, required)
  failure_impact: "Cascading failure if any service is down"

# CORRECT: Loose coupling with async events
order-service:
  publishes:
    - OrderCreatedEvent
    - OrderCancelledEvent
  subscribes:
    - PaymentProcessedEvent
    - InventoryReservedEvent
  resilience: "Can operate with degraded functionality"
```

**Chatty Interface Anti-Pattern:**
```python
# WRONG: Multiple calls for single operation
class ChattyOrderService:
    async def get_order_details(self, order_id):
        order = await self.order_api.get_order(order_id)
        customer = await self.customer_api.get_customer(order.customer_id)
        for item in order.items:
            product = await self.product_api.get_product(item.product_id)
            item.product_details = product
        return order

# CORRECT: Aggregated response
class OptimizedOrderService:
    async def get_order_details(self, order_id):
        # Single call with embedded data
        return await self.order_api.get_order_with_details(
            order_id,
            include=['customer', 'products', 'shipping']
        )
```
