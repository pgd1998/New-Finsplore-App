package com.finsplore.dto;

import com.fasterxml.jackson.annotation.JsonInclude;

/**
 * DTO for requesting an auth link from Basiq API.
 * Mobile number is optional - if not provided, Basiq will collect it on their hosted page.
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public class BasiqAuthLinkRequest {
    private String[] scope = {"SERVER_ACCESS"};
    // Remove mobile field completely - let Basiq handle mobile collection on their page

    public BasiqAuthLinkRequest() {
        // Minimal request - Basiq will handle all user input collection
    }

    public BasiqAuthLinkRequest(String userMobile) {
        // Ignore userMobile parameter - Basiq will collect mobile on their hosted page
        // This constructor exists for backward compatibility
    }

    public String[] getScope() {
        return scope;
    }

    public void setScope(String[] scope) {
        this.scope = scope;
    }
}
