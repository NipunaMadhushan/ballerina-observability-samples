# Shop Tracing Demo

Two Ballerina services with distributed tracing (Jaeger) and metrics (Prometheus) enabled.

```
Client
  └─► shop-service          (port 8090)
          └─► inventory-data-service  (port 8091)
                  └─► H2 database (create-database/resources/shop_data)
```

## Services

| Service | Port | Description |
|---|---|---|
| `shop-service` | 8090 | HTTP front-end that clients call |
| `inventory-data-service` | 8091 | Stores and fetches data from a local H2 database |

## Setup

### 1. Create the database

```bash
cd create-database
bal run
```

### 2. Start inventory-data-service

```bash
cd inventory-data-service
bal run
```

### 3. Start shop-service

```bash
cd shop-service
bal run
```

## API Endpoints

### Shop Service (port 8090)

| Method | Path | Description |
|---|---|---|
| GET | `/shop/products` | List all products |
| GET | `/shop/products/{id}` | Get a single product |
| POST | `/shop/orders` | Place an order |
| GET | `/shop/orders` | List all orders |

Use `shop-service/shop-request.http` to send sample requests.

### Inventory Data Service (port 8091)

| Method | Path | Description |
|---|---|---|
| GET | `/inventory/products` | List all products from DB |
| GET | `/inventory/products/{id}` | Get a single product from DB |
| POST | `/inventory/orders` | Create an order in DB |
| GET | `/inventory/orders` | List all orders from DB |

## Observability

Both services export traces to Jaeger (OTLP gRPC on `localhost:4317`) and expose Prometheus metrics.

To see traces, start a Jaeger all-in-one container:

```bash
docker run -d --name jaeger \
  -p 16686:16686 \
  -p 4317:4317 \
  jaegertracing/all-in-one:latest
```

Then open `http://localhost:16686` and select `nipunal/shop_service` or `nipunal/inventory_data_service` from the service dropdown.

The `inventoryServiceUrl` in `shop-service/Config.toml` can be changed to point to a remote instance.
