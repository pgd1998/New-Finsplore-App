package com.finsplore.dto;

/**
 * DTO for creating a user in the Basiq API.
 */
public class BasiqUserRequest {
    private String email;
    private String mobile;
    private String firstName;
    private String lastName;

    public BasiqUserRequest(String email, String mobile, String firstName, String lastName) {
        this.email = email;
        this.mobile = mobile;
        this.firstName = firstName;
        this.lastName = lastName;
    }

    public String getEmail() { 
        return email; 
    }
    
    public String getMobile() { 
        return mobile; 
    }
    
    public String getFirstName() { 
        return firstName; 
    }
    
    public String getLastName() { 
        return lastName; 
    }
}
