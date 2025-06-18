package com.finsplore.dto;

import java.time.LocalDate;

public class BillDto {
    private Long userId;
    private Double amount;
    private String name;
    private LocalDate date;

    // Default constructor
    public BillDto() {}

    public BillDto(Long userId, String name, Double amount, String date) {
        this.userId = userId;
        this.name = name;
        this.amount = amount;
        this.date = LocalDate.parse(date);
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
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public LocalDate getDate() {
        return date;
    }
    
    public void setDate(LocalDate date) {
        this.date = date;
    }
}
