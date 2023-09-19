package com.chtrembl.orderitemsreserver.service;

import com.chtrembl.orderitemsreserver.domain.Order;
import com.chtrembl.orderitemsreserver.domain.Response;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.core.io.WritableResource;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.io.OutputStream;
import java.util.function.Function;

@Slf4j
@Component
public class ReserverFunction implements Function<String, Response> {
    private static final String BLOB_RESOURCE_PATTERN = "azure-blob://%s/%s";

    private final String containerName;
    private final ResourceLoader resourceLoader;
    private final ObjectMapper objectMapper;

    public ReserverFunction(
        @Value("${spring.cloud.azure.storage.blob.container-name}") String containerName,
        ResourceLoader resourceLoader,
        ObjectMapper objectMapper
    ) {
        this.containerName = containerName;
        this.resourceLoader = resourceLoader;
        this.objectMapper = objectMapper;
    }

    @Override
    public Response apply(String orderMessage) {
        try {
            Order order = objectMapper.readValue(orderMessage, Order.class);
            upload(order.getId(), orderMessage);
            return new Response("Order items reserved and saved into Blob Storage");
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    private void upload(String fileName, String data) throws IOException {
        Resource resource = resourceLoader.getResource(
            String.format(BLOB_RESOURCE_PATTERN, containerName, fileName)
        );
        try (OutputStream os = ((WritableResource) resource).getOutputStream()) {
            os.write(data.getBytes());
        }
    }
}
