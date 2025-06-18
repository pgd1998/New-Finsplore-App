package com.finsplore.dto;

import lombok.Data;
import java.time.ZonedDateTime;

/**
 * Data Transfer Object for user profile responses.
 * 
 * @author Finsplore Team
 */
@Data
public class UserProfileResponse {

    private Long id;
    private String email;
    private String firstName;
    private String middleName;
    private String lastName;
    private String mobileNumber;
    private String username;
    private String basiqUserId;
    private String avatarUrl;
    private Double monthlyBudget;
    private Double savingsGoal;
    private Boolean isEmailVerified;
    private Boolean isActive;
    private ZonedDateTime emailVerifiedAt;
    private ZonedDateTime createdAt;
    private ZonedDateTime updatedAt;
    private ZonedDateTime lastLoginAt;

    /**
     * Returns the user's full name
     */
    public String getFullName() {
        StringBuilder fullName = new StringBuilder();
        if (firstName != null) {
            fullName.append(firstName);
        }
        if (middleName != null && !middleName.trim().isEmpty()) {
            if (fullName.length() > 0) fullName.append(" ");
            fullName.append(middleName);
        }
        if (lastName != null) {
            if (fullName.length() > 0) fullName.append(" ");
            fullName.append(lastName);
        }
        return fullName.toString().trim();
    }

    /**
     * Returns display name for the user (username or first name or email)
     */
    public String getDisplayName() {
        if (username != null && !username.trim().isEmpty()) {
            return username;
        }
        if (firstName != null && !firstName.trim().isEmpty()) {
            return firstName;
        }
        return email;
    }

    /**
     * Checks if user has completed basic profile setup
     */
    public boolean isProfileComplete() {
        return firstName != null && lastName != null && mobileNumber != null;
    }
}
