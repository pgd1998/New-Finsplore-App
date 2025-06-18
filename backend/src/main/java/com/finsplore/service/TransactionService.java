package com.finsplore.service;

import com.finsplore.common.ErrorCode;
import com.finsplore.dto.TransactionResponse;
import com.finsplore.dto.TransactionSummaryResponse;
import com.finsplore.entity.Transaction;
import com.finsplore.entity.TransactionCategory;
import com.finsplore.entity.User;
import com.finsplore.exception.BusinessException;
import com.finsplore.repository.TransactionCategoryRepository;
import com.finsplore.repository.TransactionRepository;
import com.finsplore.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Service for transaction management operations.
 * 
 * Handles transaction CRUD operations, categorization, analytics, and external service integration.
 * 
 * @author Finsplore Team
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class TransactionService {

    private final TransactionRepository transactionRepository;
    private final TransactionCategoryRepository categoryRepository;
    private final UserRepository userRepository;
    private final BasiqService basiqService;
    private final OpenAIService openAIService;

    /**
     * Get paginated user transactions with filters
     */
    public Page<TransactionResponse> getUserTransactions(String userEmail, Pageable pageable, 
            String category, LocalDate startDate, LocalDate endDate, String search) {
        
        log.info("Getting transactions for user: {} with filters - category: {}, startDate: {}, endDate: {}, search: {}", 
                userEmail, category, startDate, endDate, search);
        
        User user = findUserByEmail(userEmail);
        
        // Build dynamic query using Specification
        Specification<Transaction> spec = Specification.where(null);
        
        // Filter by user
        spec = spec.and((root, query, cb) -> cb.equal(root.get("user").get("id"), user.getId()));
        
        // Filter by category if provided
        if (category != null && !category.trim().isEmpty()) {
            spec = spec.and((root, query, cb) -> 
                cb.like(cb.lower(root.get("category").get("name")), "%" + category.toLowerCase() + "%"));
        }
        
        // Filter by date range
        if (startDate != null) {
            spec = spec.and((root, query, cb) -> 
                cb.greaterThanOrEqualTo(root.get("transactionDate"), startDate));
        }
        if (endDate != null) {
            spec = spec.and((root, query, cb) -> 
                cb.lessThanOrEqualTo(root.get("transactionDate"), endDate));
        }
        
        // Filter by search term (description or merchant)
        if (search != null && !search.trim().isEmpty()) {
            String searchTerm = "%" + search.toLowerCase() + "%";
            spec = spec.and((root, query, cb) -> 
                cb.or(
                    cb.like(cb.lower(root.get("description")), searchTerm),
                    cb.like(cb.lower(root.get("merchantName")), searchTerm)
                ));
        }
        
        Page<Transaction> transactions = transactionRepository.findAll(spec, pageable);
        
        return transactions.map(TransactionResponse::fromEntity);
    }

    /**
     * Get transaction summary for date range
     */
    public TransactionSummaryResponse getTransactionSummary(String userEmail, LocalDate startDate, LocalDate endDate) {
        log.info("Getting transaction summary for user: {} from {} to {}", userEmail, startDate, endDate);
        
        User user = findUserByEmail(userEmail);
        
        List<Transaction> transactions = transactionRepository
                .findByUserIdAndTransactionDateBetween(user.getId(), startDate, endDate);
        
        TransactionSummaryResponse summary = new TransactionSummaryResponse();
        summary.setStartDate(startDate);
        summary.setEndDate(endDate);
        summary.setTotalTransactions((long) transactions.size());
        
        BigDecimal totalIncome = BigDecimal.ZERO;
        BigDecimal totalExpenses = BigDecimal.ZERO;
        long incomeCount = 0;
        long expenseCount = 0;
        BigDecimal largestIncome = BigDecimal.ZERO;
        BigDecimal largestExpense = BigDecimal.ZERO;
        
        // Calculate totals and find largest transactions
        for (Transaction transaction : transactions) {
            if (transaction.isIncome()) {
                totalIncome = totalIncome.add(transaction.getAmount());
                incomeCount++;
                if (transaction.getAmount().compareTo(largestIncome) > 0) {
                    largestIncome = transaction.getAmount();
                }
            } else {
                totalExpenses = totalExpenses.add(transaction.getAmount().abs());
                expenseCount++;
                if (transaction.getAmount().abs().compareTo(largestExpense) > 0) {
                    largestExpense = transaction.getAmount().abs();
                }
            }
        }
        
        summary.setTotalIncome(totalIncome);
        summary.setTotalExpenses(totalExpenses);
        summary.setNetAmount(totalIncome.subtract(totalExpenses));
        summary.setIncomeTransactions(incomeCount);
        summary.setExpenseTransactions(expenseCount);
        summary.setLargestIncome(largestIncome);
        summary.setLargestExpense(largestExpense);
        
        // Calculate average transaction amount
        if (!transactions.isEmpty()) {
            BigDecimal totalAmount = transactions.stream()
                    .map(Transaction::getAbsoluteAmount)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);
            summary.setAverageTransactionAmount(
                    totalAmount.divide(BigDecimal.valueOf(transactions.size()), 2, BigDecimal.ROUND_HALF_UP));
        }
        
        // Find top expense and income categories
        findTopCategories(transactions, summary);
        
        return summary;
    }

    /**
     * Get specific transaction by ID
     */
    public TransactionResponse getUserTransaction(String userEmail, String transactionId) {
        log.info("Getting transaction {} for user: {}", transactionId, userEmail);
        
        User user = findUserByEmail(userEmail);
        
        Transaction transaction = transactionRepository.findByIdAndUserId(transactionId, user.getId())
                .orElseThrow(() -> new BusinessException(ErrorCode.TRANSACTION_NOT_FOUND, "Transaction not found"));
        
        return TransactionResponse.fromEntity(transaction);
    }

    /**
     * Update transaction category
     */
    @Transactional
    public TransactionResponse updateTransactionCategory(String userEmail, String transactionId, Long categoryId) {
        log.info("Updating category for transaction {} to category {} for user: {}", transactionId, categoryId, userEmail);
        
        User user = findUserByEmail(userEmail);
        
        Transaction transaction = transactionRepository.findByIdAndUserId(transactionId, user.getId())
                .orElseThrow(() -> new BusinessException(ErrorCode.TRANSACTION_NOT_FOUND, "Transaction not found"));
        
        TransactionCategory category = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new BusinessException(ErrorCode.CATEGORY_NOT_FOUND, "Category not found"));
        
        // Verify category belongs to user or is a system category
        if (category.getUser() != null && !category.getUser().getId().equals(user.getId())) {
            throw new BusinessException(ErrorCode.FORBIDDEN, "Cannot use another user's category");
        }
        
        transaction.setCategoryByUser(category);
        Transaction updatedTransaction = transactionRepository.save(transaction);
        
        log.info("Successfully updated transaction {} category to {}", transactionId, category.getName());
        
        return TransactionResponse.fromEntity(updatedTransaction);
    }

    /**
     * Fetch transactions from external banking service
     */
    @Transactional
    public void fetchUserTransactions(String userEmail) {
        log.info("Fetching transactions from bank for user: {}", userEmail);
        
        User user = findUserByEmail(userEmail);
        
        if (user.getBasiqUserId() == null) {
            throw new BusinessException(ErrorCode.BASIQ_USER_NOT_FOUND, 
                    "No bank account linked. Please connect your bank account first.");
        }
        
        try {
            // Fetch transactions from Basiq API
            basiqService.fetchUserTransactions(user.getBasiqUserId());
            
            // TODO: Process and save the fetched transactions
            // This should:
            // 1. Get transactions from Basiq response
            // 2. Check for duplicates using external transaction ID
            // 3. Categorize new transactions using AI
            // 4. Save to database
            
            log.info("Successfully initiated transaction fetch for user: {}", userEmail);
            
        } catch (Exception e) {
            log.error("Failed to fetch transactions for user: {}", userEmail, e);
            throw new BusinessException(ErrorCode.EXTERNAL_SERVICE_ERROR, 
                    "Failed to fetch transactions from bank. Please try again later.");
        }
    }

    /**
     * Get transactions by category
     */
    public List<TransactionResponse> getTransactionsByCategory(String userEmail, Long categoryId, 
            LocalDate startDate, LocalDate endDate) {
        
        log.info("Getting transactions by category {} for user: {}", categoryId, userEmail);
        
        User user = findUserByEmail(userEmail);
        
        List<Transaction> transactions;
        if (startDate != null && endDate != null) {
            transactions = transactionRepository
                    .findByUserIdAndCategoryIdAndTransactionDateBetween(user.getId(), categoryId, startDate, endDate);
        } else {
            transactions = transactionRepository.findByUserIdAndCategoryId(user.getId(), categoryId);
        }
        
        return transactions.stream()
                .map(TransactionResponse::fromEntity)
                .collect(Collectors.toList());
    }

    /**
     * Get recent transactions
     */
    public List<TransactionResponse> getRecentTransactions(String userEmail, int limit) {
        log.info("Getting {} recent transactions for user: {}", limit, userEmail);
        
        User user = findUserByEmail(userEmail);
        
        List<Transaction> transactions = transactionRepository
                .findTopByUserIdOrderByTransactionDateDesc(user.getId(), limit);
        
        return transactions.stream()
                .map(TransactionResponse::fromEntity)
                .collect(Collectors.toList());
    }

    /**
     * Get spending trends
     */
    public Object getSpendingTrends(String userEmail, String period, int periods) {
        log.info("Getting spending trends for user: {} - period: {}, count: {}", userEmail, period, periods);
        
        User user = findUserByEmail(userEmail);
        
        // TODO: Implement actual trends analysis
        // This should calculate spending trends over time periods
        // For now, return basic structure
        
        Map<String, Object> trends = new HashMap<>();
        trends.put("period", period);
        trends.put("periods", periods);
        trends.put("data", new ArrayList<>());
        trends.put("message", "Trends analysis coming soon");
        
        return trends;
    }

    /**
     * Search transactions
     */
    public List<TransactionResponse> searchTransactions(String userEmail, String query, int limit) {
        log.info("Searching transactions for user: {} with query: {}", userEmail, query);
        
        User user = findUserByEmail(userEmail);
        
        List<Transaction> transactions = transactionRepository
                .searchTransactions(user.getId(), query, limit);
        
        return transactions.stream()
                .map(TransactionResponse::fromEntity)
                .collect(Collectors.toList());
    }

    /**
     * Categorize transaction using AI
     */
    @Transactional
    public void categorizeTransactionWithAI(String transactionId) {
        Transaction transaction = transactionRepository.findById(transactionId)
                .orElseThrow(() -> new BusinessException(ErrorCode.TRANSACTION_NOT_FOUND, "Transaction not found"));
        
        if (transaction.getIsCategorizedByUser()) {
            log.debug("Skipping AI categorization for user-categorized transaction: {}", transactionId);
            return;
        }
        
        try {
            String suggestedCategory = openAIService.categorizeTransaction(
                    transaction.getDescription(), 
                    transaction.getAmount().doubleValue()
            );
            
            transaction.setAiCategory(suggestedCategory, BigDecimal.valueOf(0.8)); // Default confidence
            transactionRepository.save(transaction);
            
            log.info("AI categorized transaction {} as: {}", transactionId, suggestedCategory);
            
        } catch (Exception e) {
            log.error("Failed to categorize transaction {} with AI", transactionId, e);
            // Don't fail the transaction processing, just log the error
        }
    }

    /**
     * Helper method to find user by email
     */
    private User findUserByEmail(String email) {
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new BusinessException(ErrorCode.USER_NOT_FOUND, "User not found"));
    }

    /**
     * Helper method to find top spending categories
     */
    private void findTopCategories(List<Transaction> transactions, TransactionSummaryResponse summary) {
        Map<String, BigDecimal> expenseCategories = new HashMap<>();
        Map<String, BigDecimal> incomeCategories = new HashMap<>();
        
        for (Transaction transaction : transactions) {
            String categoryName = transaction.getEffectiveCategoryName();
            
            if (transaction.isExpense()) {
                expenseCategories.merge(categoryName, transaction.getAbsoluteAmount(), BigDecimal::add);
            } else {
                incomeCategories.merge(categoryName, transaction.getAmount(), BigDecimal::add);
            }
        }
        
        // Find top expense category
        expenseCategories.entrySet().stream()
                .max(Map.Entry.comparingByValue())
                .ifPresent(entry -> {
                    summary.setTopExpenseCategory(entry.getKey());
                    summary.setTopExpenseCategoryAmount(entry.getValue());
                });
        
        // Find top income category
        incomeCategories.entrySet().stream()
                .max(Map.Entry.comparingByValue())
                .ifPresent(entry -> {
                    summary.setTopIncomeCategory(entry.getKey());
                    summary.setTopIncomeCategoryAmount(entry.getValue());
                });
    }
}
