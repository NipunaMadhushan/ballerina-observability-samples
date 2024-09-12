import ballerina/io;
import ballerinax/java.jdbc;

type Item record {|
    readonly int id;
    string name;
    decimal price;
    int quantity;
|};

type ShoppingItems record {|
    Item[] vegetables;
    Item[] fruits;
    Item[] fish;
    Item[] beverages;
    Item[] groceries;
    Item[] homeware;
    Item[] household;
    Item[] pharmacy;
|};

const JSON_FILE = "./resources/data.json";

public function main() returns error? {
    ShoppingItems shoppingItems = check readStudentDataFromJson(JSON_FILE);

    jdbc:Client dbClient = check new ("jdbc:h2:" + "./resources/shopping_items_data", "root", "root");

    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS vegetables (
                                    id integer AUTO_INCREMENT PRIMARY KEY,
                                    name text, 
                                    price decimal,
                                    quantity integer
                                    )`);

    foreach Item item in shoppingItems.vegetables {
        _ = check dbClient->execute(`INSERT INTO vegetables VALUES (
            ${item.id.toString()},
            ${item.name},
            ${item.price.toString()},
            ${item.quantity.toString()}
            )`);
    }

    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS fruits (
                                    id integer AUTO_INCREMENT PRIMARY KEY,
                                    name text, 
                                    price decimal,
                                    quantity integer
                                    )`);

    foreach Item item in shoppingItems.fruits {
        _ = check dbClient->execute(`INSERT INTO fruits VALUES (
            ${item.id.toString()},
            ${item.name},
            ${item.price.toString()},
            ${item.quantity.toString()}
            )`);
    }

    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS fish (
                                    id integer AUTO_INCREMENT PRIMARY KEY,
                                    name text, 
                                    price decimal,
                                    quantity integer
                                    )`);

    foreach Item item in shoppingItems.fish {
        _ = check dbClient->execute(`INSERT INTO fish VALUES (
            ${item.id.toString()},
            ${item.name},
            ${item.price.toString()},
            ${item.quantity.toString()}
            )`);
    }

    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS beverages (
                                    id integer AUTO_INCREMENT PRIMARY KEY,
                                    name text, 
                                    price decimal,
                                    quantity integer
                                    )`);

    foreach Item item in shoppingItems.beverages {
        _ = check dbClient->execute(`INSERT INTO beverages VALUES (
            ${item.id.toString()},
            ${item.name},
            ${item.price.toString()},
            ${item.quantity.toString()}
            )`);
    }

    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS groceries (
                                    id integer AUTO_INCREMENT PRIMARY KEY,
                                    name text, 
                                    price decimal,
                                    quantity integer
                                    )`);

    foreach Item item in shoppingItems.groceries {
        _ = check dbClient->execute(`INSERT INTO groceries VALUES (
            ${item.id.toString()},
            ${item.name},
            ${item.price.toString()},
            ${item.quantity.toString()}
            )`);
    }

    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS homeware (
                                    id integer AUTO_INCREMENT PRIMARY KEY,
                                    name text, 
                                    price decimal,
                                    quantity integer
                                    )`);

    foreach Item item in shoppingItems.homeware {
        _ = check dbClient->execute(`INSERT INTO homeware VALUES (
            ${item.id.toString()},
            ${item.name},
            ${item.price.toString()},
            ${item.quantity.toString()}
            )`);
    }

    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS household (
                                    id integer AUTO_INCREMENT PRIMARY KEY,
                                    name text, 
                                    price decimal,
                                    quantity integer
                                    )`);

    foreach Item item in shoppingItems.household {
        _ = check dbClient->execute(`INSERT INTO household VALUES (
            ${item.id.toString()},
            ${item.name},
            ${item.price.toString()},
            ${item.quantity.toString()}
            )`);
    }

    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS pharmacy (
                                    id integer AUTO_INCREMENT PRIMARY KEY,
                                    name text, 
                                    price decimal,
                                    quantity integer
                                    )`);

    foreach Item item in shoppingItems.pharmacy {
        _ = check dbClient->execute(`INSERT INTO pharmacy VALUES (
            ${item.id.toString()},
            ${item.name},
            ${item.price.toString()},
            ${item.quantity.toString()}
            )`);
    }
}

function readStudentDataFromJson(string filePath) returns ShoppingItems|error {
    json payload = check io:fileReadJson(filePath);
    ShoppingItems shoppingItems = check payload.fromJsonWithType();

    return shoppingItems;
}
