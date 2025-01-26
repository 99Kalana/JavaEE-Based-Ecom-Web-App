package org.example.javaee_ecommerce_web_application_aad;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter

public class ProductsDTO {

    private String product_id;
    private String product_name;
    private String description;
    private double price;
    private int stock;
    private String category_id;
    private String category_name;
    private String image_path;

}
