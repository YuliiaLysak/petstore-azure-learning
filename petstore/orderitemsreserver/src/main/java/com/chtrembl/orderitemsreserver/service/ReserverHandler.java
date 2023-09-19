package com.chtrembl.orderitemsreserver.service;

import com.microsoft.azure.functions.ExecutionContext;
import com.microsoft.azure.functions.annotation.FixedDelayRetry;
import com.microsoft.azure.functions.annotation.FunctionName;
import com.microsoft.azure.functions.annotation.ServiceBusQueueTrigger;
import org.springframework.stereotype.Component;

@Component
public class ReserverHandler {

    private final ReserverFunction reserverFunction;

    public ReserverHandler(ReserverFunction reserverFunction) {
        this.reserverFunction = reserverFunction;
    }

    @FunctionName("reserve-order-items")
    @FixedDelayRetry(maxRetryCount = 3, delayInterval = "00:00:05")
    public void execute(
        @ServiceBusQueueTrigger(
            name = "order",
            queueName = "reserved-order-items",
            connection = "AzureWebJobsServiceBus"
        ) String order,
        ExecutionContext context
    ) {
        reserverFunction.apply(order);
    }
}
