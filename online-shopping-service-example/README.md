# Exam portal service

## Overview

In this example, I have implemented an online shopping service to order groceries. Shopping items are divided into 8 categories as follows.

    1. vegetables
    2. fruits
    3. fish
    4. beverages
    5. groceries
    6. homeware
    7. household
    8. pharmacy

User can get the available categories using the following resource.

GET http://localhost:8091/online-shopping/item-categories

There are 8 http resources to get the available items in the shop.

1. GET http://localhost:8091/online-shopping/vegetables
2. GET http://localhost:8091/online-shopping/fruits
3. GET http://localhost:8091/online-shopping/fish
4. GET http://localhost:8091/online-shopping/beverages
5. GET http://localhost:8091/online-shopping/groceries
6. GET http://localhost:8091/online-shopping/homeware
7. GET http://localhost:8091/online-shopping/household
8. GET http://localhost:8091/online-shopping/pharmacy

Data of the items are represented in json format and item id is unique for each item.

```json
{
    "id": 1,
    "name": "Pineapple",
    "price": 2,
    "quantity": 10
}
```

The following 8 http resources will add the items to the cart.

1. POST http://localhost:8091/online-shopping/vegetables/add-to-cart
    payload - `BuyingItem[]`
2. POST http://localhost:8091/online-shopping/fruits/add-to-cart
    payload - `BuyingItem[]`
3. POST http://localhost:8091/online-shopping/fish/add-to-cart
    payload - `BuyingItem[]`
4. POST http://localhost:8091/online-shopping/beverages/add-to-cart
    payload - `BuyingItem[]`
5. POST http://localhost:8091/online-shopping/groceries/add-to-cart
    payload - `BuyingItem[]`
6. POST http://localhost:8091/online-shopping/homeware/add-to-cart
    payload - `BuyingItem[]`
7. POST http://localhost:8091/online-shopping/household/add-to-cart
    payload - `BuyingItem[]`
8. POST http://localhost:8091/online-shopping/pharmacy/add-to-cart
    payload - `BuyingItem[]`

You can get the picked items on cart using the following resource.

GET http://localhost:8091/online-shopping/cart


## Create database

`data.json` in the `create-database/resources` directory contains data of the shopping items. Please run the following command in the `create-database` directory to create the database.

`$ bal run`

Then the `shopping_items_data.mv.db` file will be created in the `create-database/resources` directory.

## Run online shopping service

Go to the `online-shopping-service` directory and run the following command to start the service.

`$ bal run`

User can send the requests by using the `shopping-request.http`.


## Observe Service metrics and traces

Ballerina provides observability data for metrics and tracing with `OpenTelemetry`.

1. ### Enable observability

To enable observability in ballerina, user have to configure the following in `Ballerina.toml`.

```toml
[build-options]
observabilityIncluded = true
```

2. ### Configure tracing provider and metrics reporter

User can set the tracing provider and the metrics reporter in the `Config.toml` as follows.

```toml
[ballerina.observe]
tracingEnabled=true
tracingProvider="jaeger"
metricsEnabled=true
metricsReporter="prometheus"
```

I have used `Prometheus` as metrics reporter and `Jaeger` as tracing provider. There are other metric reporters and tracing providers as well in Ballerina.

* Metric reporters - prometheus, newrelic
* Tracing providers - jaeger, zipkin, newrelic

3. ### Configure hostname and port

User can configure the agent hostname & port for the Jaeger tracing provider endpoint as follows in the `Config.toml`. Otherwise it will use the default values.

```toml
[ballerinax.jaeger]
agentHostname="localhost"  # Optional Configuration. Default value is localhost
agentPort=4317             # Optional Configuration. Default value is 55680
```

For more information on Ballerina Observability, please visit [Observe Ballerina Programs](https://ballerina.io/learn/observe-ballerina-programs/).
