import ballerina/http;
import ballerina/log;
import ballerinax/jaeger as _;

type Product record {|
    int id;
    string name;
    string category;
    decimal price;
    int stockQuantity;
|};

type Order record {|
    int id;
    int productId;
    int quantity;
    decimal totalPrice;
|};

type OrderRequest record {|
    int productId;
    int quantity;
|};

// URL of the downstream inventory-data-service; overridable via Config.toml
configurable string inventoryServiceUrl = "http://localhost:8091";

final http:Client inventoryClient = check new (inventoryServiceUrl);

@display {
    label: "Shop Service"
}
service /shop on new http:Listener(8090) {

    // Lists all available products by delegating to inventory-data-service
    resource function get products() returns Product[]|error {
        log:printInfo("GET /shop/products -> inventory-data-service");
        return check inventoryClient->get("/inventory/products");
    }

    // Returns a single product; propagates 404 from inventory-data-service
    resource function get products/[int id]() returns Product|http:NotFound|error {
        log:printInfo(string `GET /shop/products/${id} -> inventory-data-service`);
        http:Response response = check inventoryClient->get(string `/inventory/products/${id}`);
        if response.statusCode == 404 {
            return http:NOT_FOUND;
        }
        json payload = check response.getJsonPayload();
        return check payload.cloneWithType(Product);
    }

    // Places an order; delegates stock validation and persistence to inventory-data-service
    resource function post orders(@http:Payload OrderRequest orderReq) returns Order|http:BadRequest|error {
        log:printInfo(string `POST /shop/orders productId=${orderReq.productId} qty=${orderReq.quantity} -> inventory-data-service`);
        http:Response response = check inventoryClient->post("/inventory/orders", orderReq);
        if response.statusCode == 400 {
            string reason = check response.getTextPayload();
            return <http:BadRequest>{body: reason};
        }
        json payload = check response.getJsonPayload();
        return check payload.cloneWithType(Order);
    }

    // Lists all placed orders by delegating to inventory-data-service
    resource function get orders() returns Order[]|error {
        log:printInfo("GET /shop/orders -> inventory-data-service");
        return check inventoryClient->get("/inventory/orders");
    }
}
