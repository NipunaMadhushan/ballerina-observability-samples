# Exam portal service

## Overview

In this example, I have implemented a exam portal service to publish students results, get students results and send results to students. I have included ballerina observability to view distributed tracing via `ballerinax/zipkin` library.

There are mainly three http resources as follows.

1. POST /exam/submit/results 
    
    payload - `Students[]`
2. GET /exam/results/<STUDENT_ID>
3. GET /exam/results/<STUDENT_ID>/sendemail

data of the students are represented in json format and student id is unique for each student.

```json
{
    "studentId": 1,
    "name":"Mary Jane",
    "age":15,
    "className":"Class A",
    "email":"enter_your_email@gmail.com",
    "mathematics":79,
    "science":82,
    "english":91,
    "history":88,
    "geography":71,
    "music":68,
    "total":479,
    "average":79.83,
    "rank":5
}
```

## Observability with Zipkin

1. #### Enable observability

To enable observability in ballerina, user have to configure the following in `Ballerina.toml`.

```toml
[build-options]
observabilityIncluded = true
```

2. #### Configure tracing provider

User should provide the tracing provider as `zipkin` in `Config.toml`.


```toml
[ballerina.observe]
tracingEnabled=true
tracingProvider="zipkin"
```

3. #### Configure hostname and port

User can configure the agent hostname & port for the zipkin tracing data reporter endpoint as follows in the `Config.toml`. Otherwise it will use the default values.

```toml
[ballerinax.zipkin]
agentHostname="localhost"  # Optional Configuration. Default value is localhost
agentPort=9411             # Optional Configuration. Default value is 9411
```

User can directly configure the reporter endpoint as well and it will override agent hostname & port.

```toml
[ballerinax.zipkin]
reporterEndpoint="<TRACE_API>"
```

## Sending requests to service

1. To submit results to database, create `request.json` file with the following content format.

```json
[
    {
        "studentId": 11,
        "name":"Anne Sherly",
        "age":16,
        "className":"Class B",
        "email":"enter_your_email@gmail.com",
        "mathematics":69,
        "science":62,
        "english":81,
        "history":89,
        "geography":74,
        "music":67,
        "total":442,
        "average":73.67
    }
]
```

Then run the following command in your terminal.

```
curl -X POST --data @request.json http://localhost:8090/exam/submit/results --header "Content-Type:application/json"
```

2. To get results, run the following command and response will be contained the results in json format.

```
curl http://localhost:8090/exam/results/11
```

3. To send results to the student email, run the following command.

```
curl http://localhost:8090/exam/results/11/sendemail
```

## Publishing tracing data to new relic

User can publish traces to new relic in zipkin format via `TRACE_API`. User need to have an account in new relic.

To configure the API key in Newrelic:

> Go to Profile -> API keys -> Insights Insert key -> Insert keys to create an account in New Relic.

> For other vendors, please consult the respective documentations.

User should configure the reporter endpoint as follows.

```toml
[ballerinax.zipkin]
reporterEndpoint="https://trace-api.newrelic.com/trace/v1?Api-Key=<NEW_RELIC_LICENSE_KEY>&Data-Format=zipkin&Data-Format-Version=2"
```
