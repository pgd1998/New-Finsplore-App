package com.finsplore.dto;

/**
 * DTO for representing the token response from the Basiq API.
 */
public class BasiqTokenResponse {
    private String access_token;

    public String getAccessToken() {
        return access_token;
    }

    public void setAccess_token(String access_token) {
        this.access_token = access_token;
    }
}
