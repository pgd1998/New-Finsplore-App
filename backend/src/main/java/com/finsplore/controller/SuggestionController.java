package com.finsplore.controller;

import com.finsplore.entity.FinancialSuggestion;
import com.finsplore.entity.User;
import com.finsplore.service.SuggestionService;
import com.finsplore.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Map;
import java.math.BigDecimal;

@RestController
@RequestMapping("/api/suggestions")
public class SuggestionController {

    @Autowired
    private SuggestionService suggestionService;

    @Autowired
    private UserRepository userRepository;

    @PostMapping("/create")
    public ResponseEntity<FinancialSuggestion> createSuggestion(@RequestBody Map<String, Object> request) {
        Long userId = Long.parseLong(request.get("userId").toString());
        String suggestionText = (String) request.get("suggestionText");
        Double expectedSaveAmount = Double.parseDouble(request.get("expectedSaveAmount").toString());

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));

        FinancialSuggestion suggestion = new FinancialSuggestion(
            suggestionText,
            suggestionText, // Use same text for description
            FinancialSuggestion.SuggestionType.GENERAL_TIP,
            user
        );
        suggestion.setPotentialSavings(BigDecimal.valueOf(expectedSaveAmount));
        FinancialSuggestion savedSuggestion = suggestionService.saveSuggestion(suggestion);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedSuggestion);
    }

    @GetMapping("/{userId}")
    public ResponseEntity<List<FinancialSuggestion>> getSuggestionsByUserId(@PathVariable Long userId) {
        return ResponseEntity.ok(suggestionService.getSuggestionsByUserId(userId));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteSuggestion(@PathVariable Long id) {
        suggestionService.deleteSuggestion(id);
        return ResponseEntity.noContent().build();
    }
}
