import ballerina/http;
import ballerinax/java.jdbc;
import ballerinax/jaeger as _;
import ballerinax/prometheus as _;

type Item record {|
    readonly int id;
    string name;
    decimal price;
    int quantity;
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

const DATABASE_FILE = "./../create-database/resources/shopping_items_data";

Cart cart;
final jdbc:Client dbClient;

@display {
    label: "Online Shopping Service"
}
service /online\-shopping on new http:Listener(8091) {

    function init() returns error? {
        dbClient = check new ("jdbc:h2:" + DATABASE_FILE, "root", "root");
        cart = [];
    }

    isolated resource function get vegetables() returns Item[]|error? {
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

    resource function post fruits/add\-to\-cart(@http:Payload record {| int itemId; int quantity; |} item) returns http:Response|error? {
        stream<Item, error?> items = dbClient->query(`SELECT * FROM fruits WHERE ID = ${item.itemId}`);

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

    resource function post fish/add\-to\-cart(@http:Payload record {| int itemId; int quantity; |} item) returns http:Response|error? {
        stream<Item, error?> items = dbClient->query(`SELECT * FROM fish WHERE ID = ${item.itemId}`);

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

    resource function post beverages/add\-to\-cart(@http:Payload record {| int itemId; int quantity; |} item) returns http:Response|error? {
        stream<Item, error?> items = dbClient->query(`SELECT * FROM beverages WHERE ID = ${item.itemId}`);

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

    resource function post groceries/add\-to\-cart(@http:Payload record {| int itemId; int quantity; |} item) returns http:Response|error? {
        stream<Item, error?> items = dbClient->query(`SELECT * FROM groceries WHERE ID = ${item.itemId}`);

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

    resource function post homeware/add\-to\-cart(@http:Payload record {| int itemId; int quantity; |} item) returns http:Response|error? {
        stream<Item, error?> items = dbClient->query(`SELECT * FROM homeware WHERE ID = ${item.itemId}`);

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

    resource function post household/add\-to\-cart(@http:Payload record {| int itemId; int quantity; |} item) returns http:Response|error? {
        stream<Item, error?> items = dbClient->query(`SELECT * FROM household WHERE ID = ${item.itemId}`);

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

    resource function post pharmacy/add\-to\-cart(@http:Payload record {| int itemId; int quantity; |} item) returns http:Response|error? {
        stream<Item, error?> items = dbClient->query(`SELECT * FROM pharmacy WHERE ID = ${item.itemId}`);

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
