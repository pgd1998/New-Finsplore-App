package com.finsplore.dto;

public class BudgetRequest {
    private Long userId;
    private Double amount;

    // Default constructor
    public BudgetRequest() {}

    public BudgetRequest(Long userId, Double amount) {
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
