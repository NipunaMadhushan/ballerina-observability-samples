import ballerina/http;
import ballerina/io;
import ballerina/log;
import ballerina/observe;
import ballerinax/prometheus as _;

//Create a counter as a global variable in the service with the optional field description.
observe:Counter totalTakeawayOrders = new ("total_orders",
                                    desc = "Total quantity required",
                                    tags = {"method": "GET", "order_type" : "takeaway"});
observe:Counter totalDiningOrders = new ("total_orders",
                                    desc = "Total quantity required",
                                    tags = {"method": "GET", "order_type" : "dining"});

service /online\-store\-service on new http:Listener(9091) {

    function init() {
        error? result = totalTakeawayOrders.register();
        if (result is error) {
            log:printError("Error registering the counter metric 'total_orders': ", result);
        }
        result = totalDiningOrders.register();
        if (result is error) {
            log:printError("Error registering the counter metric 'total_orders': ", result);
        }
    }
    resource function get make\-order\-takeaway(http:Caller caller, http:Request req) {
        //Incrementing the global counter defined with the default value 1.
        totalTakeawayOrders.increment();

        //Get the total count of the counter.
        int totalTakeawayOrdersCount = totalTakeawayOrders.getValue();
        io:println("Total takeaway orders: ", totalTakeawayOrdersCount);

        //Send reponse to the client.
        http:Response res = new;
        // Use a util method to set a string payload.
        res.setPayload("Order Processed!");

        // Send the response back to the caller.
        error? result = caller->respond(res);
        if (result is error) {
            log:printError("Error sending response", result);
        }
    }

    resource function get make\-order\-dining(http:Caller caller, http:Request req) {
        //Incrementing the global counter defined with the default value 1.
        totalDiningOrders.increment();

        //Get the total count of the counter.
        int totalDiningOrdersCount = totalDiningOrders.getValue();
        io:println("Total dining orders: ", totalDiningOrdersCount);

        //Send reponse to the client.
        http:Response res = new;
        // Use a util method to set a string payload.
        res.setPayload("Order Processed!");

        // Send the response back to the caller.
        error? result = caller->respond(res);
        if (result is error) {
            log:printError("Error sending response", result);
        }
    }
}
