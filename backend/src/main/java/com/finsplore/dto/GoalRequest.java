package com.finsplore.dto;

public class GoalRequest {
    private Long userId;
    private Double amount;

    // Default constructor
    public GoalRequest() {}

    public GoalRequest(Long userId, Double amount) {
        this.userId = userId;
        this.amount = amount;
    }

    // Getters and setters
    public Long getUserId() {
        return userId;
    }
    
    public void setUserId(Long userId) {
        this.userId = userId;
    }
    
    public Double getAmount() {
        return amount;
    }
    
    public void setAmount(Double amount) {
        this.amount = amount;
    }
}
