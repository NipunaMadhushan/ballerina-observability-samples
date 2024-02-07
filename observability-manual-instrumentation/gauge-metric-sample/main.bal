import ballerina/http;
import ballerina/io;
import ballerina/log;
import ballerina/observe;
import ballerinax/prometheus as _;
import ballerina/lang.runtime;

observe:Gauge ongoingTakeAwayOrders = new ("total_ongoing_orders",
                            desc = "Total Ongoing Orders",
                            tags = {"method": "GET", "order_type" : "takeaway"});

observe:Gauge ongoingDiningOrders = new ("total_ongoing_orders",
                            desc = "Total Ongoing Orders",
                            tags = {"method": "GET", "order_type" : "dining"});

service /online\-store\-service on new http:Listener(9091) {
    function init() returns error? {
        // Register the counter metric into global metric registry.
        error? result = ongoingTakeAwayOrders.register();
        if (result is error) {
            log:printError("Error registering the counter metric 'total_orders': ", result);
        }

        // Register the counter metric into global metric registry.
        result = ongoingDiningOrders.register();
        if (result is error) {
            log:printError("Error registering the counter metric 'total_orders': ", result);
        }

        // Add a common tag to metrics.
        result = check observe:addTagToMetrics("service_name", "online-store-service");
        if (result is error) {
            log:printError("Error adding tag to metrics: ", result);
        }
    }

    resource function get make\-order\-takeaway(http:Caller caller, http:Request req) {
        //Send reponse to the client.
        http:Response res = new;
        // Use a util method to set a string payload.
        res.setPayload("Order Accepted!");

        // Send the response back to the caller.
        error? result = caller->respond(res);
        if (result is error) {
            log:printError("Error sending response", result);
        }

        // Increment the counter metric.
        ongoingTakeAwayOrders.increment();

        // Start a new process to process the order.
        future<error?> processResult = start processOrder(TAKEAWAY);
        if (processResult is future<error>) {
            log:printError("Error processing order");
        }
    }     

    resource function get make\-order\-dining(http:Caller caller, http:Request req) {
        //Send reponse to the client.
        http:Response res = new;
        // Use a util method to set a string payload.
        res.setPayload("Order Accepted!");

        // Send the response back to the caller.
        error? result = caller->respond(res);
        if (result is error) {
            log:printError("Error sending response", result);
        }

        // Increment the counter metric.
        ongoingDiningOrders.increment();

        // Start a new process to process the order.
        future<error?> processResult = start processOrder(DINING);
        if (processResult is future<error>) {
            log:printError("Error processing order");
        }
    }     
}

function processOrder(OrderType orderType) returns error? {
    io:println("Processing order...");
    int waitingTime = getWaitingTime(orderType);
    int i = 0;
    while i < waitingTime {
        runtime:sleep(1);
        i += 1;
    } 
    io:println("Order processed!");

    // Decrement the counter metric.
    if (orderType == TAKEAWAY) {
        ongoingTakeAwayOrders.decrement();
    } else {
        ongoingDiningOrders.decrement();
    }
}

function getWaitingTime(OrderType orderType) returns int {
    if (orderType == TAKEAWAY) {
        return 10;
    } else {
        return 15;
    }
}

enum OrderType {
    TAKEAWAY,
    DINING
}
