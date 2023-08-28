package com.chtrembl.orderitemsreserver.service;

import com.chtrembl.orderitemsreserver.domain.Order;
import com.microsoft.azure.functions.ExecutionContext;
import com.microsoft.azure.functions.HttpMethod;
import com.microsoft.azure.functions.HttpRequestMessage;
import com.microsoft.azure.functions.HttpResponseMessage;
import com.microsoft.azure.functions.HttpStatus;
import com.microsoft.azure.functions.annotation.AuthorizationLevel;
import com.microsoft.azure.functions.annotation.FunctionName;
import com.microsoft.azure.functions.annotation.HttpTrigger;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class ReserverHandler {

    private final ReserverFunction reserverFunction;

    public ReserverHandler(ReserverFunction reserverFunction) {
        this.reserverFunction = reserverFunction;
    }

    @FunctionName("reserve-order-items")
    public HttpResponseMessage execute(
        @HttpTrigger(
            name = "request",
            methods = {HttpMethod.POST},
            authLevel = AuthorizationLevel.ANONYMOUS
        ) HttpRequestMessage<Optional<Order>> request,
        ExecutionContext context
    ) {
        Order order = request.getBody().orElse(new Order());
        return request
            .createResponseBuilder(HttpStatus.OK)
            .body(reserverFunction.apply(order))
            .header("Content-Type", "application/json")
            .build();
    }
}
