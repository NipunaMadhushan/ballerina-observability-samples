import ballerina/io;
import ballerinax/java.jdbc;

type Product record {|
    int id;
    string name;
    string category;
    decimal price;
    int stockQuantity;
|};

type ProductsData record {|
    Product[] products;
|};

const DB_PATH = "./resources/shop_data";
const JSON_FILE = "./resources/data.json";

public function main() returns error? {
    io:println("Setting up shop database...");

    ProductsData data = check readFromJson(JSON_FILE);
    jdbc:Client dbClient = check new ("jdbc:h2:" + DB_PATH, "root", "root");

    _ = check dbClient->execute(`DROP TABLE IF EXISTS orders`);
    _ = check dbClient->execute(`DROP TABLE IF EXISTS products`);

    _ = check dbClient->execute(`CREATE TABLE products (
        id               INTEGER AUTO_INCREMENT PRIMARY KEY,
        name             VARCHAR(255) NOT NULL,
        category         VARCHAR(100) NOT NULL,
        price            DECIMAL(10,2) NOT NULL,
        stock_quantity   INTEGER NOT NULL
    )`);

    _ = check dbClient->execute(`CREATE TABLE orders (
        id           INTEGER AUTO_INCREMENT PRIMARY KEY,
        product_id   INTEGER NOT NULL,
        quantity     INTEGER NOT NULL,
        total_price  DECIMAL(10,2) NOT NULL,
        FOREIGN KEY (product_id) REFERENCES products(id)
    )`);

    foreach Product product in data.products {
        _ = check dbClient->execute(`INSERT INTO products (name, category, price, stock_quantity)
            VALUES (${product.name}, ${product.category}, ${product.price}, ${product.stockQuantity})`);
    }

    io:println("Database setup complete! Inserted " + data.products.length().toString() + " products.");
    check dbClient.close();
}

function readFromJson(string filePath) returns ProductsData|error {
    json content = check io:fileReadJson(filePath);
    return content.cloneWithType(ProductsData);
}
