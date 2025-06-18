package com.finsplore.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.Optional;

import com.finsplore.dto.BudgetRequest;
import com.finsplore.entity.User;
import com.finsplore.service.UserService;

@RestController
@RequestMapping("/api/budget")
public class BudgetController {
    @Autowired
    private UserService userService;

    @PatchMapping("/set")
    public ResponseEntity<String> setBudget(@RequestBody BudgetRequest budgetRequest) {
        // Logic to store budget info (e.g., call service to save to DB)
        Long userId = budgetRequest.getUserId();
        Double amount = budgetRequest.getAmount();
        
        return userService.updateUserBudget(userId, amount)
                .map(unused -> ResponseEntity.ok("Budget set successfully"))
                .orElseGet(() -> ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found"));
    }

    @GetMapping("/{userId}")
    public ResponseEntity<BudgetRequest> getBudget(@PathVariable Long userId) {
        return userService.getUserBudget(userId)
                .map(budget -> ResponseEntity.ok(new BudgetRequest(userId, budget)))
                .orElseGet(() -> ResponseEntity.notFound().build());
    }
}
