package com.finsplore.repository;

import com.finsplore.entity.Transaction;
import com.finsplore.entity.TransactionCategory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 * Repository interface for Transaction entity operations.
 * 
 * Optimized for handling thousands of transactions per user with proper indexing.
 * Includes analytical queries for financial insights and reporting.
 * 
 * @author Finsplore Team
 */
@Repository
public interface TransactionRepository extends JpaRepository<Transaction, String>, JpaSpecificationExecutor<Transaction> {

    // Basic User Transaction Queries

    /**
     * Finds all transactions for a user, ordered by date (most recent first)
     */
    @Query("SELECT t FROM Transaction t WHERE t.user.id = :userId ORDER BY t.transactionDate DESC, t.createdAt DESC")
    Page<Transaction> findByUserIdOrderByDateDesc(@Param("userId") Long userId, Pageable pageable);

    /**
     * Finds transactions for a user within a date range
     */
    @Query("SELECT t FROM Transaction t WHERE t.user.id = :userId AND t.transactionDate BETWEEN :startDate AND :endDate ORDER BY t.transactionDate DESC")
    Page<Transaction> findByUserIdAndDateRange(@Param("userId") Long userId, 
                                               @Param("startDate") LocalDate startDate, 
                                               @Param("endDate") LocalDate endDate, 
                                               Pageable pageable);

    /**
     * Finds recent transactions for a user (limit by number)
     */
    @Query("SELECT t FROM Transaction t WHERE t.user.id = :userId ORDER BY t.transactionDate DESC, t.createdAt DESC")
    List<Transaction> findRecentTransactionsByUserId(@Param("userId") Long userId, Pageable pageable);

    // Account-Specific Queries

    /**
     * Finds transactions for a specific account
     */
    @Query("SELECT t FROM Transaction t WHERE t.user.id = :userId AND t.accountId = :accountId ORDER BY t.transactionDate DESC")
    Page<Transaction> findByUserIdAndAccountId(@Param("userId") Long userId, 
                                               @Param("accountId") String accountId, 
                                               Pageable pageable);

    /**
     * Gets distinct account IDs for a user
     */
    @Query("SELECT DISTINCT t.accountId FROM Transaction t WHERE t.user.id = :userId AND t.accountId IS NOT NULL")
    List<String> findDistinctAccountIdsByUserId(@Param("userId") Long userId);

    // Category-Based Queries

    /**
     * Finds transactions by category
     */
    @Query("SELECT t FROM Transaction t WHERE t.user.id = :userId AND t.category = :category ORDER BY t.transactionDate DESC")
    Page<Transaction> findByUserIdAndCategory(@Param("userId") Long userId, 
                                              @Param("category") TransactionCategory category, 
                                              Pageable pageable);

    /**
     * Finds uncategorized transactions for a user
     */
    @Query("SELECT t FROM Transaction t WHERE t.user.id = :userId AND t.category IS NULL ORDER BY t.transactionDate DESC")
    Page<Transaction> findUncategorizedByUserId(@Param("userId") Long userId, Pageable pageable);

    /**
     * Finds transactions that need user categorization (AI suggested but not confirmed)
     */
    @Query("SELECT t FROM Transaction t WHERE t.user.id = :userId AND t.isCategorizedByUser = false AND t.aiSuggestedCategory IS NOT NULL ORDER BY t.transactionDate DESC")
    Page<Transaction> findTransactionsNeedingUserCategorization(@Param("userId") Long userId, Pageable pageable);

    // Amount and Direction Queries

    /**
     * Finds income transactions (positive amounts)
     */
    @Query("SELECT t FROM Transaction t WHERE t.user.id = :userId AND t.amount > 0 ORDER BY t.transactionDate DESC")
    Page<Transaction> findIncomeTransactionsByUserId(@Param("userId") Long userId, Pageable pageable);

    /**
     * Finds expense transactions (negative amounts)
     */
    @Query("SELECT t FROM Transaction t WHERE t.user.id = :userId AND t.amount < 0 ORDER BY t.transactionDate DESC")
    Page<Transaction> findExpenseTransactionsByUserId(@Param("userId") Long userId, Pageable pageable);

    /**
     * Finds transactions above a certain amount
     */
    @Query("SELECT t FROM Transaction t WHERE t.user.id = :userId AND ABS(t.amount) >= :minAmount ORDER BY ABS(t.amount) DESC")
    Page<Transaction> findLargeTransactionsByUserId(@Param("userId") Long userId, 
                                                    @Param("minAmount") BigDecimal minAmount, 
                                                    Pageable pageable);

    // Search Queries

    /**
     * Searches transactions by description
     */
    @Query("SELECT t FROM Transaction t WHERE t.user.id = :userId AND LOWER(t.description) LIKE LOWER(CONCAT('%', :searchTerm, '%')) ORDER BY t.transactionDate DESC")
    Page<Transaction> searchTransactionsByDescription(@Param("userId") Long userId, 
                                                      @Param("searchTerm") String searchTerm, 
                                                      Pageable pageable);

    /**
     * Searches transactions by merchant name
     */
    @Query("SELECT t FROM Transaction t WHERE t.user.id = :userId AND LOWER(t.merchantName) LIKE LOWER(CONCAT('%', :searchTerm, '%')) ORDER BY t.transactionDate DESC")
    Page<Transaction> searchTransactionsByMerchant(@Param("userId") Long userId, 
                                                   @Param("searchTerm") String searchTerm, 
                                                   Pageable pageable);

    // Analytical Queries

    /**
     * Calculates total spending for a user within a date range
     */
    @Query("SELECT COALESCE(SUM(ABS(t.amount)), 0) FROM Transaction t WHERE t.user.id = :userId AND t.amount < 0 AND t.transactionDate BETWEEN :startDate AND :endDate")
    BigDecimal calculateTotalSpendingInDateRange(@Param("userId") Long userId, 
                                                 @Param("startDate") LocalDate startDate, 
                                                 @Param("endDate") LocalDate endDate);

    /**
     * Calculates total income for a user within a date range
     */
    @Query("SELECT COALESCE(SUM(t.amount), 0) FROM Transaction t WHERE t.user.id = :userId AND t.amount > 0 AND t.transactionDate BETWEEN :startDate AND :endDate")
    BigDecimal calculateTotalIncomeInDateRange(@Param("userId") Long userId, 
                                               @Param("startDate") LocalDate startDate, 
                                               @Param("endDate") LocalDate endDate);

    /**
     * Calculates net amount (income - expenses) for a date range
     */
    @Query("SELECT COALESCE(SUM(t.amount), 0) FROM Transaction t WHERE t.user.id = :userId AND t.transactionDate BETWEEN :startDate AND :endDate")
    BigDecimal calculateNetAmountInDateRange(@Param("userId") Long userId, 
                                             @Param("startDate") LocalDate startDate, 
                                             @Param("endDate") LocalDate endDate);

    /**
     * Gets spending by category for a user within a date range
     */
    @Query("SELECT t.category.name, SUM(ABS(t.amount)) FROM Transaction t " +
           "WHERE t.user.id = :userId AND t.amount < 0 AND t.transactionDate BETWEEN :startDate AND :endDate " +
           "AND t.category IS NOT NULL " +
           "GROUP BY t.category.name " +
           "ORDER BY SUM(ABS(t.amount)) DESC")
    List<Object[]> getSpendingByCategory(@Param("userId") Long userId, 
                                         @Param("startDate") LocalDate startDate, 
                                         @Param("endDate") LocalDate endDate);

    /**
     * Gets daily spending totals for a date range
     */
    @Query("SELECT t.transactionDate, SUM(ABS(t.amount)) FROM Transaction t " +
           "WHERE t.user.id = :userId AND t.amount < 0 AND t.transactionDate BETWEEN :startDate AND :endDate " +
           "GROUP BY t.transactionDate " +
           "ORDER BY t.transactionDate")
    List<Object[]> getDailySpendingTotals(@Param("userId") Long userId, 
                                          @Param("startDate") LocalDate startDate, 
                                          @Param("endDate") LocalDate endDate);

    /**
     * Gets monthly spending totals for a user
     */
    @Query("SELECT EXTRACT(YEAR FROM t.transactionDate), EXTRACT(MONTH FROM t.transactionDate), SUM(ABS(t.amount)) " +
           "FROM Transaction t " +
           "WHERE t.user.id = :userId AND t.amount < 0 " +
           "GROUP BY EXTRACT(YEAR FROM t.transactionDate), EXTRACT(MONTH FROM t.transactionDate) " +
           "ORDER BY EXTRACT(YEAR FROM t.transactionDate), EXTRACT(MONTH FROM t.transactionDate)")
    List<Object[]> getMonthlySpendingTotals(@Param("userId") Long userId);

    // Duplicate and Data Quality Queries

    /**
     * Finds potential duplicate transactions based on external transaction ID
     */
    @Query("SELECT t FROM Transaction t WHERE t.externalTransactionId = :externalId")
    Optional<Transaction> findByExternalTransactionId(@Param("externalId") String externalTransactionId);

    /**
     * Checks if a transaction exists for a user with specific details
     */
    @Query("SELECT COUNT(t) > 0 FROM Transaction t WHERE t.user.id = :userId AND t.amount = :amount AND t.transactionDate = :date AND t.description = :description")
    boolean existsSimilarTransaction(@Param("userId") Long userId, 
                                     @Param("amount") BigDecimal amount, 
                                     @Param("date") LocalDate date, 
                                     @Param("description") String description);

    // Recurring Transaction Detection

    /**
     * Finds transactions that might be recurring (same merchant, similar amounts)
     */
    @Query("SELECT t FROM Transaction t WHERE t.user.id = :userId AND t.merchantName = :merchantName AND ABS(t.amount - :amount) < :tolerance ORDER BY t.transactionDate DESC")
    List<Transaction> findSimilarTransactions(@Param("userId") Long userId, 
                                              @Param("merchantName") String merchantName, 
                                              @Param("amount") BigDecimal amount, 
                                              @Param("tolerance") BigDecimal tolerance);

    /**
     * Finds transactions marked as recurring
     */
    @Query("SELECT t FROM Transaction t WHERE t.user.id = :userId AND t.isRecurring = true ORDER BY t.transactionDate DESC")
    List<Transaction> findRecurringTransactionsByUserId(@Param("userId") Long userId);

    // AI and Categorization Queries

    /**
     * Finds transactions with low AI confidence scores that may need review
     */
    @Query("SELECT t FROM Transaction t WHERE t.user.id = :userId AND t.confidenceScore < :threshold ORDER BY t.confidenceScore ASC")
    List<Transaction> findLowConfidenceTransactions(@Param("userId") Long userId, @Param("threshold") BigDecimal threshold);

    /**
     * Gets count of transactions by categorization status
     */
    @Query("SELECT " +
           "SUM(CASE WHEN t.category IS NOT NULL THEN 1 ELSE 0 END) as categorized, " +
           "SUM(CASE WHEN t.category IS NULL AND t.aiSuggestedCategory IS NOT NULL THEN 1 ELSE 0 END) as aiSuggested, " +
           "SUM(CASE WHEN t.category IS NULL AND t.aiSuggestedCategory IS NULL THEN 1 ELSE 0 END) as uncategorized " +
           "FROM Transaction t WHERE t.user.id = :userId")
    Object[] getCategorizationStats(@Param("userId") Long userId);

    // Performance Queries

    /**
     * Counts total transactions for a user
     */
    @Query("SELECT COUNT(t) FROM Transaction t WHERE t.user.id = :userId")
    Long countByUserId(@Param("userId") Long userId);

    /**
     * Gets the date range of transactions for a user
     */
    @Query("SELECT MIN(t.transactionDate), MAX(t.transactionDate) FROM Transaction t WHERE t.user.id = :userId")
    Object[] getTransactionDateRange(@Param("userId") Long userId);

    /**
     * Finds the most recent transaction for a user
     */
    @Query("SELECT t FROM Transaction t WHERE t.user.id = :userId ORDER BY t.transactionDate DESC, t.createdAt DESC")
    Optional<Transaction> findMostRecentByUserId(@Param("userId") Long userId, Pageable pageable);

    // Batch Operations

    /**
     * Updates category for multiple transactions
     */
    @Query("UPDATE Transaction t SET t.category = :category, t.isCategorizedByUser = true, t.lastCategorizedAt = CURRENT_TIMESTAMP WHERE t.id IN :transactionIds AND t.user.id = :userId")
    int updateCategoryForTransactions(@Param("userId") Long userId, 
                                      @Param("transactionIds") List<String> transactionIds, 
                                      @Param("category") TransactionCategory category);

    /**
     * Marks transactions as recurring
     */
    @Query("UPDATE Transaction t SET t.isRecurring = true WHERE t.id IN :transactionIds AND t.user.id = :userId")
    int markTransactionsAsRecurring(@Param("userId") Long userId, @Param("transactionIds") List<String> transactionIds);

    // Additional methods needed by TransactionService

    /**
     * Finds transactions for a user within a date range (List version)
     */
    @Query("SELECT t FROM Transaction t WHERE t.user.id = :userId AND t.transactionDate BETWEEN :startDate AND :endDate ORDER BY t.transactionDate DESC")
    List<Transaction> findByUserIdAndTransactionDateBetween(@Param("userId") Long userId, 
                                                          @Param("startDate") LocalDate startDate, 
                                                          @Param("endDate") LocalDate endDate);

    /**
     * Finds a transaction by ID and user ID
     */
    @Query("SELECT t FROM Transaction t WHERE t.id = :transactionId AND t.user.id = :userId")
    Optional<Transaction> findByIdAndUserId(@Param("transactionId") String transactionId, @Param("userId") Long userId);

    /**
     * Finds transactions by user ID and category ID
     */
    @Query("SELECT t FROM Transaction t WHERE t.user.id = :userId AND t.category.id = :categoryId ORDER BY t.transactionDate DESC")
    List<Transaction> findByUserIdAndCategoryId(@Param("userId") Long userId, @Param("categoryId") Long categoryId);

    /**
     * Finds transactions by user ID, category ID and date range
     */
    @Query("SELECT t FROM Transaction t WHERE t.user.id = :userId AND t.category.id = :categoryId AND t.transactionDate BETWEEN :startDate AND :endDate ORDER BY t.transactionDate DESC")
    List<Transaction> findByUserIdAndCategoryIdAndTransactionDateBetween(@Param("userId") Long userId, 
                                                                        @Param("categoryId") Long categoryId,
                                                                        @Param("startDate") LocalDate startDate, 
                                                                        @Param("endDate") LocalDate endDate);

    /**
     * Finds recent transactions for a user
     */
    @Query(value = "SELECT t FROM Transaction t WHERE t.user.id = :userId ORDER BY t.transactionDate DESC, t.createdAt DESC")
    List<Transaction> findTopByUserIdOrderByTransactionDateDesc(@Param("userId") Long userId, Pageable pageable);

    default List<Transaction> findTopByUserIdOrderByTransactionDateDesc(Long userId, int limit) {
        return findTopByUserIdOrderByTransactionDateDesc(userId, PageRequest.of(0, limit));
    }

    /**
     * Search transactions by description or merchant name
     */
    @Query("SELECT t FROM Transaction t WHERE t.user.id = :userId AND " +
           "(LOWER(t.description) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
           "LOWER(t.merchantName) LIKE LOWER(CONCAT('%', :query, '%'))) " +
           "ORDER BY t.transactionDate DESC")
    List<Transaction> searchTransactionsByQuery(@Param("userId") Long userId, @Param("query") String query, Pageable pageable);

    default List<Transaction> searchTransactions(Long userId, String query, int limit) {
        return searchTransactionsByQuery(userId, query, PageRequest.of(0, limit));
    }
}
