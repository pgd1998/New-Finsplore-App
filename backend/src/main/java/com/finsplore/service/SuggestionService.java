package com.finsplore.service;

import com.finsplore.entity.FinancialSuggestion;
import com.finsplore.repository.FinancialSuggestionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SuggestionService {

    @Autowired
    private FinancialSuggestionRepository suggestionRepository;

    public FinancialSuggestion saveSuggestion(FinancialSuggestion suggestion) {
        return suggestionRepository.save(suggestion);
    }

    public List<FinancialSuggestion> getSuggestionsByUserId(Long userId) {
        return suggestionRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }

    public void deleteSuggestion(Long id) {
        suggestionRepository.deleteById(id);
    }
}
