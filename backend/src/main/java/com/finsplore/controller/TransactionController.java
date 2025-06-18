package com.finsplore.controller;

import com.finsplore.common.ApiResponse;
import com.finsplore.dto.TransactionResponse;
import com.finsplore.dto.TransactionSummaryResponse;
import com.finsplore.service.TransactionService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

/**
 * REST Controller for transaction management operations.
 * 
 * Provides endpoints for viewing, categorizing, and analyzing financial transactions.
 * 
 * @author Finsplore Team
 */
@Slf4j
@RestController
@RequestMapping("/api/transactions")
@RequiredArgsConstructor
public class TransactionController {

    private final TransactionService transactionService;

    /**
     * Get paginated list of user's transactions
     */
    @GetMapping
    public ResponseEntity<ApiResponse<Page<TransactionResponse>>> getTransactions(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(defaultValue = "transactionDate") String sortBy,
            @RequestParam(defaultValue = "desc") String sortDir,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
            @RequestParam(required = false) String search) {

        String userEmail = getCurrentUserEmail();
        
        Sort.Direction direction = sortDir.equalsIgnoreCase("desc") ? Sort.Direction.DESC : Sort.Direction.ASC;
        Pageable pageable = PageRequest.of(page, size, Sort.by(direction, sortBy));
        
        Page<TransactionResponse> transactions = transactionService.getUserTransactions(
                userEmail, pageable, category, startDate, endDate, search);
        
        return ResponseEntity.ok(ApiResponse.success(transactions, "Transactions retrieved successfully"));
    }

    /**
     * Get transaction summary for a date range
     */
    @GetMapping("/summary")
    public ResponseEntity<ApiResponse<TransactionSummaryResponse>> getTransactionSummary(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {

        String userEmail = getCurrentUserEmail();
        
        // Default to current month if no dates provided
        if (startDate == null) {
            startDate = LocalDate.now().withDayOfMonth(1);
        }
        if (endDate == null) {
            endDate = LocalDate.now();
        }
        
        TransactionSummaryResponse summary = transactionService.getTransactionSummary(userEmail, startDate, endDate);
        
        return ResponseEntity.ok(ApiResponse.success(summary, "Transaction summary retrieved successfully"));
    }

    /**
     * Get specific transaction by ID
     */
    @GetMapping("/{transactionId}")
    public ResponseEntity<ApiResponse<TransactionResponse>> getTransaction(@PathVariable String transactionId) {
        String userEmail = getCurrentUserEmail();
        
        TransactionResponse transaction = transactionService.getUserTransaction(userEmail, transactionId);
        
        return ResponseEntity.ok(ApiResponse.success(transaction, "Transaction retrieved successfully"));
    }

    /**
     * Update transaction category
     */
    @PutMapping("/{transactionId}/category")
    public ResponseEntity<ApiResponse<TransactionResponse>> updateTransactionCategory(
            @PathVariable String transactionId,
            @RequestParam Long categoryId) {

        String userEmail = getCurrentUserEmail();
        
        TransactionResponse updatedTransaction = transactionService.updateTransactionCategory(
                userEmail, transactionId, categoryId);
        
        return ResponseEntity.ok(ApiResponse.success(updatedTransaction, "Transaction category updated successfully"));
    }

    /**
     * Fetch latest transactions from bank accounts
     */
    @PostMapping("/fetch")
    public ResponseEntity<ApiResponse<String>> fetchTransactions() {
        String userEmail = getCurrentUserEmail();
        
        transactionService.fetchUserTransactions(userEmail);
        
        return ResponseEntity.ok(ApiResponse.success("Transaction fetch initiated successfully"));
    }

    /**
     * Get transactions by category
     */
    @GetMapping("/by-category/{categoryId}")
    public ResponseEntity<ApiResponse<List<TransactionResponse>>> getTransactionsByCategory(
            @PathVariable Long categoryId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {

        String userEmail = getCurrentUserEmail();
        
        List<TransactionResponse> transactions = transactionService.getTransactionsByCategory(
                userEmail, categoryId, startDate, endDate);
        
        return ResponseEntity.ok(ApiResponse.success(transactions, "Transactions by category retrieved successfully"));
    }

    /**
     * Get recent transactions (last 10)
     */
    @GetMapping("/recent")
    public ResponseEntity<ApiResponse<List<TransactionResponse>>> getRecentTransactions() {
        String userEmail = getCurrentUserEmail();
        
        List<TransactionResponse> transactions = transactionService.getRecentTransactions(userEmail, 10);
        
        return ResponseEntity.ok(ApiResponse.success(transactions, "Recent transactions retrieved successfully"));
    }

    /**
     * Get spending trends
     */
    @GetMapping("/trends")
    public ResponseEntity<ApiResponse<Object>> getSpendingTrends(
            @RequestParam(defaultValue = "monthly") String period,
            @RequestParam(defaultValue = "6") int periods) {

        String userEmail = getCurrentUserEmail();
        
        // TODO: Implement spending trends analysis
        Object trends = transactionService.getSpendingTrends(userEmail, period, periods);
        
        return ResponseEntity.ok(ApiResponse.success(trends, "Spending trends retrieved successfully"));
    }

    /**
     * Search transactions
     */
    @GetMapping("/search")
    public ResponseEntity<ApiResponse<List<TransactionResponse>>> searchTransactions(
            @RequestParam String query,
            @RequestParam(defaultValue = "50") int limit) {

        String userEmail = getCurrentUserEmail();
        
        List<TransactionResponse> transactions = transactionService.searchTransactions(userEmail, query, limit);
        
        return ResponseEntity.ok(ApiResponse.success(transactions, "Transaction search completed successfully"));
    }

    /**
     * Get current authenticated user's email
     */
    private String getCurrentUserEmail() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            throw new RuntimeException("User not authenticated");
        }
        return (String) authentication.getPrincipal();
    }
}
