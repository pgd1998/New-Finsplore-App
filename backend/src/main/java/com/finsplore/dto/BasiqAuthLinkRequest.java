package com.finsplore.dto;

/**
 * DTO for requesting an auth link.
 */
public class BasiqAuthLinkRequest {
    private String[] scope = {"entities", "connections", "accounts", "transactions"};

    public String[] getScope() {
        return scope;
    }

    public void setScope(String[] scope) {
        this.scope = scope;
    }
}
