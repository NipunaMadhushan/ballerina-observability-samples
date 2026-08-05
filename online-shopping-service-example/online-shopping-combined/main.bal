import ballerina/http;
import ballerina/io;
import ballerina/observe as _;
import ballerinax/jaeger as _;
import ballerinax/metrics.logs as _;
import ballerinax/java.jdbc;
import ballerina/log;

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

type BoughtItem record {|
    readonly int id;
    string name;
    string category;
    string itemId;
    decimal price;
    int quantity;
|};

type BuyingItem record {|
    int itemId;
    int quantity;
|};

type CartItem record {|
    int id;
    string name;
    decimal price;
    int quantity;
    decimal totalPrice;
|};

type Cart BoughtItem[];

final string[] & readonly categories = ["vegetables", "fruits", "fish", "beverages", "groceries", "homeware", "household", "pharmacy"];

const JSON_FILE = "./resources/data.json";

Cart cart;
final jdbc:Client dbClient = check new ("jdbc:h2:mem:shopping_items_data;DB_CLOSE_DELAY=-1", "root", "root");

function initDatabase() returns error? {
    ShoppingItems shoppingItems = check readShoppingDataFromJson(JSON_FILE);

    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS vegetables (
                                    id integer AUTO_INCREMENT PRIMARY KEY,
                                    name text,
                                    price decimal,
                                    quantity integer
                                    )`);
    foreach Item item in shoppingItems.vegetables {
        _ = check dbClient->execute(`INSERT INTO vegetables VALUES (
            ${item.id.toString()}, ${item.name}, ${item.price.toString()}, ${item.quantity.toString()})`);
    }

    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS fruits (
                                    id integer AUTO_INCREMENT PRIMARY KEY,
                                    name text,
                                    price decimal,
                                    quantity integer
                                    )`);
    foreach Item item in shoppingItems.fruits {
        _ = check dbClient->execute(`INSERT INTO fruits VALUES (
            ${item.id.toString()}, ${item.name}, ${item.price.toString()}, ${item.quantity.toString()})`);
    }

    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS fish (
                                    id integer AUTO_INCREMENT PRIMARY KEY,
                                    name text,
                                    price decimal,
                                    quantity integer
                                    )`);
    foreach Item item in shoppingItems.fish {
        _ = check dbClient->execute(`INSERT INTO fish VALUES (
            ${item.id.toString()}, ${item.name}, ${item.price.toString()}, ${item.quantity.toString()})`);
    }

    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS beverages (
                                    id integer AUTO_INCREMENT PRIMARY KEY,
                                    name text,
                                    price decimal,
                                    quantity integer
                                    )`);
    foreach Item item in shoppingItems.beverages {
        _ = check dbClient->execute(`INSERT INTO beverages VALUES (
            ${item.id.toString()}, ${item.name}, ${item.price.toString()}, ${item.quantity.toString()})`);
    }

    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS groceries (
                                    id integer AUTO_INCREMENT PRIMARY KEY,
                                    name text,
                                    price decimal,
                                    quantity integer
                                    )`);
    foreach Item item in shoppingItems.groceries {
        _ = check dbClient->execute(`INSERT INTO groceries VALUES (
            ${item.id.toString()}, ${item.name}, ${item.price.toString()}, ${item.quantity.toString()})`);
    }

    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS homeware (
                                    id integer AUTO_INCREMENT PRIMARY KEY,
                                    name text,
                                    price decimal,
                                    quantity integer
                                    )`);
    foreach Item item in shoppingItems.homeware {
        _ = check dbClient->execute(`INSERT INTO homeware VALUES (
            ${item.id.toString()}, ${item.name}, ${item.price.toString()}, ${item.quantity.toString()})`);
    }

    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS household (
                                    id integer AUTO_INCREMENT PRIMARY KEY,
                                    name text,
                                    price decimal,
                                    quantity integer
                                    )`);
    foreach Item item in shoppingItems.household {
        _ = check dbClient->execute(`INSERT INTO household VALUES (
            ${item.id.toString()}, ${item.name}, ${item.price.toString()}, ${item.quantity.toString()})`);
    }

    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS pharmacy (
                                    id integer AUTO_INCREMENT PRIMARY KEY,
                                    name text,
                                    price decimal,
                                    quantity integer
                                    )`);
    foreach Item item in shoppingItems.pharmacy {
        _ = check dbClient->execute(`INSERT INTO pharmacy VALUES (
            ${item.id.toString()}, ${item.name}, ${item.price.toString()}, ${item.quantity.toString()})`);
    }
}

function readShoppingDataFromJson(string filePath) returns ShoppingItems|error {
    json payload = check io:fileReadJson(filePath);
    return check payload.fromJsonWithType();
}

@display {
    label: "Online Shopping Service"
}
service /online\-shopping on new http:Listener(8091) {

    function init() returns error? {
        cart = [];
        check initDatabase();
    }

    isolated resource function get vegetables() returns Item[]|error? {
        http:Client helloWorldClient = check new ("http://localhost:8092");
        http:Response res = check helloWorldClient->get("/hello/greeting");
        log:printInfo("Response from Hello World Service: " + check res.getTextPayload());

        stream<Item, error?> items = dbClient->query(`SELECT * FROM vegetables`);
        Item[] vegetables = [];
        check from Item item in items
            do {
                vegetables.push(item);
            };
        return vegetables;
    }

    isolated resource function get fruits() returns Item[]|error? {
        stream<Item, error?> items = dbClient->query(`SELECT * FROM fruits`);
        Item[] fruits = [];
        check from Item item in items
            do {
                fruits.push(item);
            };
        return fruits;
    }

    isolated resource function get fish() returns Item[]|error? {
        stream<Item, error?> items = dbClient->query(`SELECT * FROM fish`);
        Item[] fish = [];
        check from Item item in items
            do {
                fish.push(item);
            };
        return fish;
    }

    isolated resource function get beverages() returns Item[]|error? {
        stream<Item, error?> items = dbClient->query(`SELECT * FROM beverages`);
        Item[] beverages = [];
        check from Item item in items
            do {
                beverages.push(item);
            };
        return beverages;
    }

    isolated resource function get groceries() returns Item[]|error? {
        stream<Item, error?> items = dbClient->query(`SELECT * FROM groceries`);
        Item[] groceries = [];
        check from Item item in items
            do {
                groceries.push(item);
            };
        return groceries;
    }

    isolated resource function get homeware() returns Item[]|error? {
        stream<Item, error?> items = dbClient->query(`SELECT * FROM homeware`);
        Item[] homeware = [];
        check from Item item in items
            do {
                homeware.push(item);
            };
        return homeware;
    }

    isolated resource function get household() returns Item[]|error? {
        stream<Item, error?> items = dbClient->query(`SELECT * FROM household`);
        Item[] household = [];
        check from Item item in items
            do {
                household.push(item);
            };
        return household;
    }

    isolated resource function get pharmacy() returns Item[]|error? {
        stream<Item, error?> items = dbClient->query(`SELECT * FROM pharmacy`);
        Item[] pharmacy = [];
        check from Item item in items
            do {
                pharmacy.push(item);
            };
        return pharmacy;
    }

    isolated resource function get item\-categories() returns string[] {
        return categories;
    }

    resource function post vegetables/add\-to\-cart(@http:Payload BuyingItem item) returns http:Response|error? {
        stream<Item, error?> items = dbClient->query(`SELECT * FROM vegetables WHERE ID = ${item.itemId}`);
        http:Response response = new;
        check from Item selectedItem in items
            do {
                BoughtItem boughtItem = {
                    id: cart.length(),
                    name: selectedItem.name,
                    category: "vegetables",
                    itemId: selectedItem.id.toString(),
                    price: selectedItem.price,
                    quantity: item.quantity
                };
                cart.push(boughtItem);
                response.setTextPayload(string `${selectedItem.name} added to the cart successfully with quantity ${item.quantity}`);
            };
        response.statusCode = 200;
        return response;
    }

    resource function post fruits/add\-to\-cart(@http:Payload BuyingItem item) returns http:Response|error? {
        stream<Item, error?> items = dbClient->query(`SELECT * FROM fruits WHERE ID = ${item.itemId}`);
        http:Response response = new;
        check from Item selectedItem in items
            do {
                BoughtItem boughtItem = {
                    id: cart.length(),
                    name: selectedItem.name,
                    category: "fruits",
                    itemId: selectedItem.id.toString(),
                    price: selectedItem.price,
                    quantity: item.quantity
                };
                cart.push(boughtItem);
                response.setTextPayload(string `${selectedItem.name} added to the cart successfully with quantity ${item.quantity}`);
            };
        response.statusCode = 200;
        return response;
    }

    resource function post fish/add\-to\-cart(@http:Payload BuyingItem item) returns http:Response|error? {
        stream<Item, error?> items = dbClient->query(`SELECT * FROM fish WHERE ID = ${item.itemId}`);
        http:Response response = new;
        check from Item selectedItem in items
            do {
                BoughtItem boughtItem = {
                    id: cart.length(),
                    name: selectedItem.name,
                    category: "fish",
                    itemId: selectedItem.id.toString(),
                    price: selectedItem.price,
                    quantity: item.quantity
                };
                cart.push(boughtItem);
                response.setTextPayload(string `${selectedItem.name} added to the cart successfully with quantity ${item.quantity}`);
            };
        response.statusCode = 200;
        return response;
    }

    resource function post beverages/add\-to\-cart(@http:Payload BuyingItem item) returns http:Response|error? {
        stream<Item, error?> items = dbClient->query(`SELECT * FROM beverages WHERE ID = ${item.itemId}`);
        http:Response response = new;
        check from Item selectedItem in items
            do {
                BoughtItem boughtItem = {
                    id: cart.length(),
                    name: selectedItem.name,
                    category: "beverages",
                    itemId: selectedItem.id.toString(),
                    price: selectedItem.price,
                    quantity: item.quantity
                };
                cart.push(boughtItem);
                response.setTextPayload(string `${selectedItem.name} added to the cart successfully with quantity ${item.quantity}`);
            };
        response.statusCode = 200;
        return response;
    }

    resource function post groceries/add\-to\-cart(@http:Payload BuyingItem item) returns http:Response|error? {
        stream<Item, error?> items = dbClient->query(`SELECT * FROM groceries WHERE ID = ${item.itemId}`);
        http:Response response = new;
        check from Item selectedItem in items
            do {
                BoughtItem boughtItem = {
                    id: cart.length(),
                    name: selectedItem.name,
                    category: "groceries",
                    itemId: selectedItem.id.toString(),
                    price: selectedItem.price,
                    quantity: item.quantity
                };
                cart.push(boughtItem);
                response.setTextPayload(string `${selectedItem.name} added to the cart successfully with quantity ${item.quantity}`);
            };
        response.statusCode = 200;
        return response;
    }

    resource function post homeware/add\-to\-cart(@http:Payload BuyingItem item) returns http:Response|error? {
        stream<Item, error?> items = dbClient->query(`SELECT * FROM homeware WHERE ID = ${item.itemId}`);
        http:Response response = new;
        check from Item selectedItem in items
            do {
                BoughtItem boughtItem = {
                    id: cart.length(),
                    name: selectedItem.name,
                    category: "homeware",
                    itemId: selectedItem.id.toString(),
                    price: selectedItem.price,
                    quantity: item.quantity
                };
                cart.push(boughtItem);
                response.setTextPayload(string `${selectedItem.name} added to the cart successfully with quantity ${item.quantity}`);
            };
        response.statusCode = 200;
        return response;
    }

    resource function post household/add\-to\-cart(@http:Payload BuyingItem item) returns http:Response|error? {
        stream<Item, error?> items = dbClient->query(`SELECT * FROM household WHERE ID = ${item.itemId}`);
        http:Response response = new;
        check from Item selectedItem in items
            do {
                BoughtItem boughtItem = {
                    id: cart.length(),
                    name: selectedItem.name,
                    category: "household",
                    itemId: selectedItem.id.toString(),
                    price: selectedItem.price,
                    quantity: item.quantity
                };
                cart.push(boughtItem);
                response.setTextPayload(string `${selectedItem.name} added to the cart successfully with quantity ${item.quantity}`);
            };
        response.statusCode = 200;
        return response;
    }

    resource function post pharmacy/add\-to\-cart(@http:Payload BuyingItem item) returns http:Response|error? {
        stream<Item, error?> items = dbClient->query(`SELECT * FROM pharmacy WHERE ID = ${item.itemId}`);
        http:Response response = new;
        check from Item selectedItem in items
            do {
                BoughtItem boughtItem = {
                    id: cart.length(),
                    name: selectedItem.name,
                    category: "pharmacy",
                    itemId: selectedItem.id.toString(),
                    price: selectedItem.price,
                    quantity: item.quantity
                };
                cart.push(boughtItem);
                response.setTextPayload(string `${selectedItem.name} added to the cart successfully with quantity ${item.quantity}`);
            };
        response.statusCode = 200;
        return response;
    }

    resource function get cart() returns http:Response|error? {
        http:Response response = new;

        if (cart.length() == 0) {
            response.setTextPayload("Your cart is empty. Please add items to the cart.");
            response.statusCode = 200;
            return response;
        }

        decimal total = 0;
        table<CartItem> cartItems = table [];
        foreach BoughtItem item in cart {
            CartItem cartItem = {
                id: item.id,
                name: item.name,
                price: item.price,
                quantity: item.quantity,
                totalPrice: item.price * item.quantity
            };
            cartItems.add(cartItem);
            total += item.price * item.quantity;
        }

        response.setJsonPayload(cartItems.toJson());
        response.statusCode = 200;

        return response;
    }
}
