package com.finsplore.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * Data Transfer Object for user login requests.
 * 
 * @author Finsplore Team
 */
@Data
public class UserLoginRequest {

    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email format")
    private String email;

    @NotBlank(message = "Password is required")
    private String password;
}
