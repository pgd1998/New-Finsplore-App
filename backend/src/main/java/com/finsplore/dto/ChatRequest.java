package com.finsplore.dto;

public class ChatRequest {
    private Long userId;
    private String message;

    // Default constructor
    public ChatRequest() {}

    // Constructor with parameters
    public ChatRequest(Long userId, String message) {
        this.userId = userId;
        this.message = message;
    }

    // Getter and Setter methods
    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
