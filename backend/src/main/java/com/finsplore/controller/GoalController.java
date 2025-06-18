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

import com.finsplore.dto.GoalRequest;
import com.finsplore.entity.User;
import com.finsplore.service.UserService;

@RestController
@RequestMapping("/api/goal")
public class GoalController {
    @Autowired
    private UserService userService;
    
    // receive the goal request and update the user goal
    @PatchMapping("/set")
    public ResponseEntity<String> setGoal(@RequestBody GoalRequest goalRequest) {
        Long userId = goalRequest.getUserId();
        Double amount = goalRequest.getAmount();
    
        return userService.updateUserGoal(userId, amount)
                .map(user -> ResponseEntity.ok("Goal set successfully"))
                .orElseGet(() -> ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found"));
    }
    
    // get the user goal
    @GetMapping("/{userId}")
    public ResponseEntity<GoalRequest> getGoal(@PathVariable Long userId) {
        return userService.getUserGoal(userId)
                .map(goal -> ResponseEntity.ok(new GoalRequest(userId, goal)))
                .orElseGet(() -> ResponseEntity.notFound().build());
    }
}
