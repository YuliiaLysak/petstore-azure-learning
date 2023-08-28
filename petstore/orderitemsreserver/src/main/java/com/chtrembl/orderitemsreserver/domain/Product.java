package com.chtrembl.orderitemsreserver.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Product {
    private Long id;
    private Category category;
    private String name;
    private String photoURL;
    private List<Tag> tags;
    private Integer quantity;
}
