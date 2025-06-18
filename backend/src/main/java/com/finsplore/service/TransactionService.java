package com.finsplore.service;

import com.finsplore.entity.Transaction;
import com.finsplore.entity.TransactionCategory;
import com.finsplore.repository.TransactionRepository;
import com.finsplore.repository.TransactionCategoryRepository;
import com.finsplore.dto.TransactionResponse;
import com.finsplore.dto.TransactionSummaryResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Service layer for Transaction management operations.
 * 
 * Handles transaction CRUD operations, categorization using AI,
 * and analytics calculations.
 * 
 * @author Finsplore Team
 */
@Service
public class TransactionService {

    @Autowired
    private TransactionRepository transactionRepository;

    @Autowired
    private TransactionCategoryRepository transactionCategoryRepository;

    @Autowired
    private OpenAIService openAIService;

    /**
     * Saves all transactions with AI categorization
     */
    public void saveAllTransactions(List<Transaction> transactions) {
        try {
            // Get existing transactions to preserve manual categorizations
            if (transactions.isEmpty()) return;
            
            List<Transaction> existingTransactions = transactionRepository.findByUserId(transactions.get(0).getUser().getId());
            
            for (Transaction transaction : transactions) {
                // Check if transaction already exists with manual categorization
                Transaction existingTransaction = existingTransactions.stream()
                    .filter(t -> t.getId().equals(transaction.getId()))
                    .findFirst()
                    .orElse(null);
                
                if (existingTransaction != null && existingTransaction.getCategory() != null) {
                    // Preserve existing manual categorization
                    transaction.setCategory(existingTransaction.getCategory());
                } else if (transaction.getCategory() == null && 
                          (transaction.getAiSuggestedCategory() == null || transaction.getAiSuggestedCategory().isEmpty())) {
                    // Apply AI categorization for new or uncategorized transactions
                    String classifiedCategory = classifyTransaction(transaction);
                    transaction.setAiSuggestedCategory(classifiedCategory);
                }
            }
            transactionRepository.saveAll(transactions);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to save transactions", e);
        }
    }

    /**
     * Gets all transactions for a user
     */
    public List<Transaction> getTransactionsByUserId(Long userId) {
        try {
            return transactionRepository.findByUserId(userId);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to retrieve transactions for userId: " + userId, e);
        }
    }

    /**
     * Gets latest 500 transactions for a user
     */
    public List<Transaction> get500TransactionsByUserId(Long userId) {
        try {
            return transactionRepository.findTop500ByUserIdOrderByTransactionDateDesc(userId);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to retrieve latest 500 transactions for userId: " + userId, e);
        }
    }

    /**
     * Gets transactions for a user by account
     */
    public List<Transaction> getTransactionsByUserIdAndAccount(Long userId, String account) {
        try {
            return transactionRepository.findByUserIdAndAccount(userId, account);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to retrieve transactions for userId: " + userId + " and account: " + account, e);
        }
    }

    /**
     * Gets latest 500 transactions for a user by account
     */
    public List<Transaction> get500TransactionsByUserIdAndAccount(Long userId, String account) {
        try {
            return transactionRepository.findTop500ByUserIdAndAccountOrderByTransactionDateDesc(userId, account);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to retrieve latest 500 transactions for userId: " + userId + " and account: " + account, e);
        }
    }

    /**
     * Classifies a transaction using AI
     */
    public String classifyTransaction(Transaction transaction) {
        if (transaction.getCategory() != null) {
            return transaction.getCategory().getName();
        }
        
        // Use predefined categories for now - this can be extended with custom user categories
        List<String> predefinedCategories = List.of(
            "Groceries", "Dining", "Transportation", "Entertainment", "Shopping", 
            "Utilities", "Healthcare", "Education", "Travel", "Income", "Other"
        );
        
        return openAIService.classifyTransaction(
            transaction.getDescription(),
            predefinedCategories,
            List.of() // Empty custom categories for now
        );
    }

    /**
     * Finds transaction by ID
     */
    public Optional<Transaction> findById(String id) {
        return transactionRepository.findById(id);
    }

    /**
     * Saves a single transaction
     */
    public Transaction saveTransaction(Transaction transaction) {
        return transactionRepository.save(transaction);
    }

    // NEW METHODS TO MATCH CONTROLLER EXPECTATIONS

    /**
     * Gets user transactions with filtering and pagination
     */
    public List<TransactionResponse> getUserTransactions(String userEmail, Pageable pageable, 
            String category, LocalDate startDate, LocalDate endDate, String searchTerm) {
        
        // For now, return all transactions for the user - can be enhanced with filtering
        Long userId = getUserIdFromEmail(userEmail);
        List<Transaction> transactions = transactionRepository.findByUserId(userId);
        
        return transactions.stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    /**
     * Gets transaction summary for date range
     */
    public TransactionSummaryResponse getTransactionSummary(String userEmail, LocalDate startDate, LocalDate endDate) {
        Long userId = getUserIdFromEmail(userEmail);
        
        // Basic implementation - can be enhanced with actual calculations
        TransactionSummaryResponse summary = new TransactionSummaryResponse();
        summary.setTotalTransactions(transactionRepository.countByUserId(userId));
        // Add more summary calculations here
        
        return summary;
    }

    /**
     * Gets a single transaction for a user
     */
    public Optional<TransactionResponse> getUserTransaction(String userEmail, String transactionId) {
        Long userId = getUserIdFromEmail(userEmail);
        
        return transactionRepository.findByIdAndUserId(transactionId, userId)
                .map(this::convertToResponse);
    }

    /**
     * Updates transaction category
     */
    public boolean updateTransactionCategory(String userEmail, String transactionId, Long categoryId) {
        Long userId = getUserIdFromEmail(userEmail);
        
        Optional<Transaction> transactionOpt = transactionRepository.findByIdAndUserId(transactionId, userId);
        Optional<TransactionCategory> categoryOpt = transactionCategoryRepository.findById(categoryId);
        
        if (transactionOpt.isPresent() && categoryOpt.isPresent()) {
            Transaction transaction = transactionOpt.get();
            transaction.setCategoryByUser(categoryOpt.get());
            transactionRepository.save(transaction);
            return true;
        }
        return false;
    }

    /**
     * Fetches transactions from external service (Basiq)
     */
    public String fetchUserTransactions(String userEmail) {
        // This would integrate with BasiqService to fetch new transactions
        // For now, return a success message
        return "Transactions fetch initiated for user: " + userEmail;
    }

    /**
     * Gets transactions by category
     */
    public List<TransactionResponse> getTransactionsByCategory(String userEmail, Long categoryId, 
            LocalDate startDate, LocalDate endDate) {
        Long userId = getUserIdFromEmail(userEmail);
        
        List<Transaction> transactions;
        if (startDate != null && endDate != null) {
            transactions = transactionRepository.findByUserIdAndCategoryIdAndTransactionDateBetween(
                userId, categoryId, startDate, endDate);
        } else {
            transactions = transactionRepository.findByUserIdAndCategoryId(userId, categoryId);
        }
        
        return transactions.stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    /**
     * Gets recent transactions
     */
    public List<TransactionResponse> getRecentTransactions(String userEmail, int limit) {
        Long userId = getUserIdFromEmail(userEmail);
        
        List<Transaction> transactions = transactionRepository.findTopByUserIdOrderByTransactionDateDesc(userId, limit);
        
        return transactions.stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    /**
     * Gets spending trends
     */
    public Object getSpendingTrends(String userEmail, String period, int limit) {
        // Placeholder implementation - return empty for now
        return "Spending trends data for " + userEmail + " over " + period;
    }

    /**
     * Searches transactions
     */
    public List<TransactionResponse> searchTransactions(String userEmail, String query, int limit) {
        Long userId = getUserIdFromEmail(userEmail);
        
        List<Transaction> transactions = transactionRepository.searchTransactions(userId, query, limit);
        
        return transactions.stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    // HELPER METHODS

    /**
     * Converts Transaction entity to TransactionResponse DTO
     */
    private TransactionResponse convertToResponse(Transaction transaction) {
        TransactionResponse response = new TransactionResponse();
        response.setId(transaction.getId());
        response.setDescription(transaction.getDescription());
        response.setAmount(transaction.getAmount());
        response.setTransactionDate(transaction.getTransactionDate());
        response.setMerchantName(transaction.getMerchantName());
        response.setCategoryName(transaction.getEffectiveCategoryName());
        response.setAccountId(transaction.getAccountId());
        return response;
    }

    /**
     * Helper method to get user ID from email
     * This should be replaced with proper user lookup
     */
    private Long getUserIdFromEmail(String email) {
        // Placeholder - in real implementation, look up user by email
        return 1L;
    }
}
