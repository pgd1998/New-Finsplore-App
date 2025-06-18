package com.finsplore.dto;

import com.finsplore.entity.Transaction;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZonedDateTime;

/**
 * Data Transfer Object for transaction responses.
 * 
 * @author Finsplore Team
 */
@Data
public class TransactionResponse {

    private String id;
    private String externalTransactionId;
    private String accountId;
    private String description;
    private BigDecimal amount;
    private LocalDate transactionDate;
    private LocalDate postedDate;
    private String transactionType;
    private String direction;
    private String originalCategory;
    private String aiSuggestedCategory;
    private String categoryName;
    private Boolean isCategorizedByUser;
    private String merchantName;
    private String referenceNumber;
    private BigDecimal balanceAfterTransaction;
    private Boolean isRecurring;
    private Boolean isInternalTransfer;
    private BigDecimal confidenceScore;
    private ZonedDateTime createdAt;
    private ZonedDateTime lastCategorizedAt;

    // Computed properties
    private BigDecimal absoluteAmount;
    private boolean isExpense;
    private boolean isIncome;
    private String effectiveCategoryName;
    private String shortDescription;

    /**
     * Creates a TransactionResponse from a Transaction entity
     */
    public static TransactionResponse fromEntity(Transaction transaction) {
        TransactionResponse response = new TransactionResponse();
        
        response.setId(transaction.getId());
        response.setExternalTransactionId(transaction.getExternalTransactionId());
        response.setAccountId(transaction.getAccountId());
        response.setDescription(transaction.getDescription());
        response.setAmount(transaction.getAmount());
        response.setTransactionDate(transaction.getTransactionDate());
        response.setPostedDate(transaction.getPostedDate());
        response.setTransactionType(transaction.getTransactionType() != null ? transaction.getTransactionType().name() : null);
        response.setDirection(transaction.getDirection() != null ? transaction.getDirection().name() : null);
        response.setOriginalCategory(transaction.getOriginalCategory());
        response.setAiSuggestedCategory(transaction.getAiSuggestedCategory());
        response.setCategoryName(transaction.getCategory() != null ? transaction.getCategory().getName() : null);
        response.setIsCategorizedByUser(transaction.getIsCategorizedByUser());
        response.setMerchantName(transaction.getMerchantName());
        response.setReferenceNumber(transaction.getReferenceNumber());
        response.setBalanceAfterTransaction(transaction.getBalanceAfterTransaction());
        response.setIsRecurring(transaction.getIsRecurring());
        response.setIsInternalTransfer(transaction.getIsInternalTransfer());
        response.setConfidenceScore(transaction.getConfidenceScore());
        response.setCreatedAt(transaction.getCreatedAt());
        response.setLastCategorizedAt(transaction.getLastCategorizedAt());

        // Set computed properties
        response.setAbsoluteAmount(transaction.getAbsoluteAmount());
        response.setExpense(transaction.isExpense());
        response.setIncome(transaction.isIncome());
        response.setEffectiveCategoryName(transaction.getEffectiveCategoryName());
        response.setShortDescription(transaction.getShortDescription());

        return response;
    }
}
