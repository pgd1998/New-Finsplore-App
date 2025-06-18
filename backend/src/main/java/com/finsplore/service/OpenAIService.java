package com.finsplore.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

/**
 * Service for integrating with OpenAI API for financial insights and AI features.
 * 
 * @author Finsplore Team
 */
@Slf4j
@Service
public class OpenAIService {

    @Value("${openai.api.key:#{null}}")
    private String openaiApiKey;
    
    @Value("${openai.enabled:false}")
    private boolean openaiEnabled;

    /**
     * Generates financial advice based on user's spending patterns
     */
    public String generateFinancialAdvice(String userSpendingData) {
        if (!openaiEnabled) {
            log.info("OpenAI service disabled - Would generate financial advice");
            return "OpenAI service is currently disabled. Please enable it in configuration to get AI-powered financial advice.";
        }

        try {
            log.info("Generating financial advice using OpenAI");
            
            // TODO: Implement actual OpenAI integration
            // This should call OpenAI API with user spending data
            // and return personalized financial advice
            
            // Placeholder implementation
            return "Based on your spending patterns, here are some AI-generated recommendations: " +
                   "1. Consider reducing dining out expenses by 15% to increase savings. " +
                   "2. Your entertainment spending is within healthy limits. " +
                   "3. Consider setting up an emergency fund with 3-6 months of expenses.";
            
        } catch (Exception e) {
            log.error("Failed to generate financial advice", e);
            return "Sorry, I'm unable to generate financial advice at the moment. Please try again later.";
        }
    }

    /**
     * Categorizes a transaction using AI
     */
    public String categorizeTransaction(String description, double amount) {
        if (!openaiEnabled) {
            log.info("OpenAI service disabled - Would categorize transaction: {}", description);
            return predictCategoryBasic(description, amount);
        }

        try {
            log.info("Categorizing transaction using OpenAI: {}", description);
            
            // TODO: Implement actual OpenAI categorization
            // This should send transaction details to OpenAI
            // and get back a category classification
            
            // Fallback to basic categorization for now
            return predictCategoryBasic(description, amount);
            
        } catch (Exception e) {
            log.error("Failed to categorize transaction with OpenAI", e);
            return predictCategoryBasic(description, amount);
        }
    }

    /**
     * Handles chat messages for the financial assistant
     */
    public String handleChatMessage(String message, String userContext) {
        if (!openaiEnabled) {
            log.info("OpenAI service disabled - Would handle chat message");
            return "I'm currently offline. Please enable the AI service to chat with me about your finances!";
        }

        try {
            log.info("Processing chat message with OpenAI");
            
            // TODO: Implement actual OpenAI chat integration
            // This should maintain conversation context
            // and provide helpful financial guidance
            
            // Placeholder response
            return "I understand you're asking about: '" + message + "'. " +
                   "As your AI financial assistant, I'm here to help with budgeting, " +
                   "spending analysis, and financial planning. " +
                   "Could you be more specific about what financial topic you'd like to discuss?";
            
        } catch (Exception e) {
            log.error("Failed to process chat message", e);
            return "I'm having trouble processing your message right now. Please try again in a moment.";
        }
    }

    /**
     * Generates insights about spending patterns
     */
    public String generateSpendingInsights(String transactionData) {
        if (!openaiEnabled) {
            log.info("OpenAI service disabled - Would generate spending insights");
            return "AI-powered insights are currently disabled. Enable OpenAI integration to get personalized spending analysis.";
        }

        try {
            log.info("Generating spending insights using OpenAI");
            
            // TODO: Implement actual spending insights generation
            // Analyze transaction patterns and provide insights
            
            // Placeholder implementation
            return "Your spending insights: " +
                   "• You've spent 12% more on groceries this month compared to last month. " +
                   "• Your coffee shop visits have increased by 3 times per week. " +
                   "• You're on track to meet your savings goal this month. " +
                   "• Consider reviewing subscription services - you have 8 active subscriptions.";
            
        } catch (Exception e) {
            log.error("Failed to generate spending insights", e);
            return "Unable to generate spending insights at the moment. Please try again later.";
        }
    }

    /**
     * Basic transaction categorization without AI
     */
    private String predictCategoryBasic(String description, double amount) {
        String desc = description.toLowerCase();
        
        // Basic keyword-based categorization
        if (desc.contains("grocery") || desc.contains("supermarket") || desc.contains("food")) {
            return "Groceries";
        } else if (desc.contains("gas") || desc.contains("fuel") || desc.contains("petrol")) {
            return "Transportation";
        } else if (desc.contains("restaurant") || desc.contains("cafe") || desc.contains("coffee")) {
            return "Dining";
        } else if (desc.contains("netflix") || desc.contains("spotify") || desc.contains("subscription")) {
            return "Entertainment";
        } else if (desc.contains("electricity") || desc.contains("water") || desc.contains("utility")) {
            return "Utilities";
        } else if (desc.contains("rent") || desc.contains("mortgage")) {
            return "Housing";
        } else if (amount > 0) {
            return "Income";
        } else {
            return "Other";
        }
    }
}
