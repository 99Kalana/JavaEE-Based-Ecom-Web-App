package org.example.javaee_ecommerce_web_application_aad;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class UserDTO {
    private String user_id;
    private String user_name;
    private String password_hash;
    private String email;
    private boolean is_active;
    private String role; // Use String to match the ENUM values (e.g., 'ADMIN', 'CUSTOMER')
}
