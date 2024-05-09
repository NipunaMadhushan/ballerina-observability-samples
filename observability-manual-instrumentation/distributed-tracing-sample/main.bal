import ballerina/http;
import ballerina/io;
import ballerina/log;
import ballerina/observe;
import ballerinax/jaeger as _;
import ballerina/lang.runtime;

int orderNumber = 0;


@display {
    label: "Online Store Service"
}
service /online\-store\-service on new http:Listener(9091) {
    resource function get make\-order\-takeaway(http:Caller caller, http:Request req) {
        // Increment the order number.
        orderNumber += 1;

        //Send reponse to the client.
        http:Response res = new;
        // Use a util method to set a string payload.
        res.setPayload("Order Accepted!");
        
        // Send the response back to the caller.
        error? result = caller->respond(res);
        if (result is error) {
            log:printError("Error sending response", result);
        }

        // Start placing the order
        future<error?> placeOrderResult = start placeOrder(orderNumber, DINING);
        if (placeOrderResult is future<error>) {
            log:printError("Error processing order");
        }
    }     

    resource function get make\-order\-dining(http:Caller caller, http:Request req) {
        // Increment the order number.
        orderNumber += 1;
        
        //Send reponse to the client.
        http:Response res = new;
        // Use a util method to set a string payload.
        res.setPayload("Order Accepted!");

        // Send the response back to the caller.
        error? result = caller->respond(res);
        if (result is error) {
            log:printError("Error sending response", result);
        }

        // Start placing the order
        future<error?> placeOrderResult = start placeOrder(orderNumber, DINING);
        if (placeOrderResult is future<error>) {
            log:printError("Error processing order");
        }
    }     
}

function placeOrder(int orderNumber, OrderType orderType) returns error? {
    // Start a new root span for the request.
    int orderSpanId = observe:startRootSpan(string `Order ${orderNumber}`);

    // Start processing the order
    error? processResult = processOrder(DINING, orderSpanId);
    if (processResult is error) {
        log:printError("Error processing order", processResult);
    }

    // Start delivering the order
    error? deliverResult = deliverOrder(orderType, orderSpanId);
    if (deliverResult is error) {
        log:printError("Error processing order", deliverResult);
    }

    // Finish the span for the order.
    error? finishOrderSpan = observe:finishSpan(orderSpanId);
    if finishOrderSpan is error {
        log:printError("Error finishing span", finishOrderSpan);
    }
}

function processOrder(OrderType orderType, int orderSpanId) returns error? {
    // Start a new span for the processing.
    int processSpanId = check observe:startSpan("Processing Order", parentSpanId = orderSpanId);

    io:println("Processing order...");
    int processingTime = getProcessingTime(orderType);
    int i = 0;
    while i < processingTime {
        runtime:sleep(1);
        i += 1;
    } 
    io:println("Order processed!");

    // Finish the span for the processing.
    error? finishProcessSpan = observe:finishSpan(processSpanId);
    if finishProcessSpan is error {
        log:printError("Error finishing span", finishProcessSpan);
    }
}

function deliverOrder(OrderType orderType, int orderSpanId) returns error? {
    // Start a new span for the delivery.
    int deliverySpanId = check observe:startSpan("Delivering Order", parentSpanId = orderSpanId);

    io:println("Delivering order...");
    int deliveringTime = getDeliveringTime(orderType);
    int i = 0;
    while i < deliveringTime {
        runtime:sleep(1);
        i += 1;
    }
    io:println("Order delivered!");

    // Finish the span for the delivery.
    error? finishDeliverySpan = observe:finishSpan(deliverySpanId);
    if finishDeliverySpan is error {
        log:printError("Error finishing span", finishDeliverySpan);
    }
}

function getProcessingTime(OrderType orderType) returns int {
    if (orderType == TAKEAWAY) {
        return 10;
    } else {
        return 15;
    }
}

function getDeliveringTime(OrderType orderType) returns int {
    if (orderType == TAKEAWAY) {
        return 20;
    } else {
        return 10;
    }
}

enum OrderType {
    TAKEAWAY,
    DINING
}
