package com.finsplore.dto;

import jakarta.validation.constraints.Size;
import lombok.Data;

/**
 * Data Transfer Object for user profile update requests.
 * 
 * @author Finsplore Team
 */
@Data
public class UserProfileUpdateRequest {

    @Size(max = 100, message = "First name must not exceed 100 characters")
    private String firstName;

    @Size(max = 100, message = "Middle name must not exceed 100 characters")
    private String middleName;

    @Size(max = 100, message = "Last name must not exceed 100 characters")
    private String lastName;

    @Size(max = 20, message = "Mobile number must not exceed 20 characters")
    private String mobileNumber;

    @Size(max = 50, message = "Username must not exceed 50 characters")
    private String username;

    @Size(max = 500, message = "Avatar URL must not exceed 500 characters")
    private String avatarUrl;

    private Double monthlyBudget;
    private Double savingsGoal;
}
