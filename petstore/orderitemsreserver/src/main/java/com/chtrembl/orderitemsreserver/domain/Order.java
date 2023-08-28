package com.chtrembl.orderitemsreserver.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.OffsetDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Order {
    private String id;
    private String email;
    private List<Product> products;
    // TODO: correctly parse dateTime
//    private OffsetDateTime shipDate;
    private OrderStatus status;
    private Boolean complete;
}
