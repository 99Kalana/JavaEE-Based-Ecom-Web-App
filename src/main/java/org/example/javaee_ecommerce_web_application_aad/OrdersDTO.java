package org.example.javaee_ecommerce_web_application_aad;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.sql.Timestamp;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class OrdersDTO {
    private String order_Id;
    private String user_Id;
    private BigDecimal total_amount;
    private Timestamp order_date;
    private String status;
}
