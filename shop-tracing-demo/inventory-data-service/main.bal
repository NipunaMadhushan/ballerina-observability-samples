import ballerina/http;
import ballerina/log;
import ballerina/sql;
import ballerinax/java.jdbc;
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

// Path to the H2 database file created by create-database module
const DATABASE_FILE = "./../create-database/resources/shop_data";

final jdbc:Client dbClient;

@display {
    label: "Inventory Data Service"
}
service /inventory on new http:Listener(8091) {

    function init() returns error? {
        dbClient = check new ("jdbc:h2:" + DATABASE_FILE, "root", "root");
        log:printInfo("Inventory Data Service started on port 8091, connected to database");
    }

    // Returns all products from the database
    resource function get products() returns Product[]|error {
        log:printInfo("DB query: SELECT all products");
        stream<Product, error?> productStream = dbClient->query(
            `SELECT id, name, category, price, stock_quantity as stockQuantity FROM products`
        );
        Product[] products = [];
        check from Product p in productStream
            do { products.push(p); };
        return products;
    }

    // Returns a single product by id
    resource function get products/[int id]() returns Product|http:NotFound|error {
        log:printInfo(string `DB query: SELECT product id=${id}`);
        stream<Product, error?> productStream = dbClient->query(
            `SELECT id, name, category, price, stock_quantity as stockQuantity
             FROM products WHERE id = ${id}`
        );
        Product[] products = [];
        check from Product p in productStream
            do { products.push(p); };
        if products.length() == 0 {
            return http:NOT_FOUND;
        }
        return products[0];
    }

    // Creates a new order after validating stock, then decrements stock
    resource function post orders(@http:Payload OrderRequest orderReq) returns Order|http:BadRequest|error {
        log:printInfo(string `DB query: SELECT product id=${orderReq.productId} for order validation`);
        stream<Product, error?> productStream = dbClient->query(
            `SELECT id, name, category, price, stock_quantity as stockQuantity
             FROM products WHERE id = ${orderReq.productId}`
        );
        Product[] products = [];
        check from Product p in productStream
            do { products.push(p); };

        if products.length() == 0 {
            return <http:BadRequest>{body: string `Product id=${orderReq.productId} not found`};
        }

        Product product = products[0];
        if product.stockQuantity < orderReq.quantity {
            return <http:BadRequest>{
                body: string `Insufficient stock: available=${product.stockQuantity}, requested=${orderReq.quantity}`
            };
        }

        decimal totalPrice = product.price * <decimal>orderReq.quantity;

        log:printInfo(string `DB insert: order productId=${orderReq.productId}, qty=${orderReq.quantity}, total=${totalPrice}`);
        sql:ExecutionResult result = check dbClient->execute(
            `INSERT INTO orders (product_id, quantity, total_price) VALUES (${orderReq.productId}, ${orderReq.quantity}, ${totalPrice})`
        );

        _ = check dbClient->execute(
            `UPDATE products SET stock_quantity = stock_quantity - ${orderReq.quantity} WHERE id = ${orderReq.productId}`
        );

        int orderId = result.lastInsertId is int ? <int>result.lastInsertId : 0;
        log:printInfo(string `Order created: id=${orderId}`);
        return {id: orderId, productId: orderReq.productId, quantity: orderReq.quantity, totalPrice: totalPrice};
    }

    // Returns all orders from the database
    resource function get orders() returns Order[]|error {
        log:printInfo("DB query: SELECT all orders");
        stream<Order, error?> orderStream = dbClient->query(
            `SELECT id, product_id as productId, quantity, total_price as totalPrice FROM orders`
        );
        Order[] orders = [];
        check from Order o in orderStream
            do { orders.push(o); };
        return orders;
    }
}
