package org.example.javaee_ecommerce_web_application_aad;


import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class CartDTO {
    private int cartId;
    private String userId;
    private String productId;
    private String productName;
    private int quantity;
    private double price;
}
