package com.finsplore.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.finsplore.dto.ChatRequest;
import com.finsplore.service.OpenAIService;

@RestController
@RequestMapping("/api/chat")
public class ChatController {

    @Autowired
    private OpenAIService openAIService;

    @PostMapping("/send")
    public ResponseEntity<String> sendMessage(@RequestBody ChatRequest chatRequest) {
        try {
            String response = openAIService.chat(chatRequest.getUserId(), chatRequest.getMessage());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                    .body("Failed send your message: " + e.getMessage());
        }
    }

    @PostMapping("/send/billReminder")
    public ResponseEntity<String> sendBillReminder(@RequestBody ChatRequest chatRequest) {
        try {
            String response = openAIService.generateBillReminder(chatRequest.getUserId(), chatRequest.getMessage());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                    .body("Bill Reminder Generation Failed: " + e.getMessage());
        }
    }

    @PostMapping("/send/suggestion")
    public ResponseEntity<String> generateSuggestion(@RequestBody ChatRequest chatRequest) {
        try {
            String response = openAIService.generateSuggestion(chatRequest.getUserId(), chatRequest.getMessage());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                    .body("Suggestion Generation Failed: " + e.getMessage());
        }
    }
}
