package com.finsplore.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.EqualsAndHashCode;
import org.hibernate.annotations.CreationTimestamp;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZonedDateTime;

/**
 * Transaction entity representing financial transactions from bank accounts.
 * 
 * Optimized for scalability to handle thousands of transactions per user:
 * - Proper indexing on frequently queried fields
 * - Efficient data types for amounts and dates
 * - Lazy loading relationships
 * 
 * @author Finsplore Team
 */
@Entity
@Table(name = "transactions", indexes = {
    @Index(name = "idx_transaction_user_id", columnList = "user_id"),
    @Index(name = "idx_transaction_date", columnList = "transaction_date"),
    @Index(name = "idx_transaction_account", columnList = "account_id"),
    @Index(name = "idx_transaction_category", columnList = "category_id"),
    @Index(name = "idx_transaction_user_date", columnList = "user_id, transaction_date"),
    @Index(name = "idx_transaction_external_id", columnList = "external_transaction_id")
})
@Getter
@Setter
@ToString(exclude = {"user", "category"})
@EqualsAndHashCode(of = "id")
public class Transaction {

    @Id
    @Column(name = "id", length = 100)
    private String id; // Using external transaction ID as primary key for deduplication

    // External Integration Fields
    @Column(name = "external_transaction_id", unique = true, length = 100)
    private String externalTransactionId; // Basiq transaction ID

    @Column(name = "account_id", length = 100)
    private String accountId; // Basiq account ID

    // Transaction Details
    @Column(name = "description", length = 500)
    private String description;

    @Column(name = "amount", precision = 15, scale = 2, nullable = false)
    private BigDecimal amount;

    @Column(name = "transaction_date", nullable = false)
    private LocalDate transactionDate;

    @Column(name = "posted_date")
    private LocalDate postedDate;

    // Transaction Type and Direction
    @Enumerated(EnumType.STRING)
    @Column(name = "transaction_type", length = 20)
    private TransactionType transactionType;

    @Enumerated(EnumType.STRING)
    @Column(name = "direction", length = 10)
    private TransactionDirection direction;

    // Categorization
    @Column(name = "original_category", length = 100)
    private String originalCategory; // Original category from bank

    @Column(name = "ai_suggested_category", length = 100)
    private String aiSuggestedCategory; // AI-suggested category

    @Column(name = "is_categorized_by_user", nullable = false)
    private Boolean isCategorizedByUser = false;

    // Additional Transaction Information
    @Column(name = "merchant_name", length = 200)
    private String merchantName;

    @Column(name = "reference_number", length = 100)
    private String referenceNumber;

    @Column(name = "balance_after_transaction", precision = 15, scale = 2)
    private BigDecimal balanceAfterTransaction;

    // Flags for Analysis
    @Column(name = "is_recurring", nullable = false)
    private Boolean isRecurring = false;

    @Column(name = "is_internal_transfer", nullable = false)
    private Boolean isInternalTransfer = false;

    @Column(name = "confidence_score", precision = 3, scale = 2)
    private BigDecimal confidenceScore; // AI categorization confidence (0.00-1.00)

    // Audit Fields
    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private ZonedDateTime createdAt;

    @Column(name = "last_categorized_at")
    private ZonedDateTime lastCategorizedAt;

    // Relationships

    /**
     * User who owns this transaction
     * Lazy loading for performance
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    /**
     * User-defined or system category for this transaction
     * Lazy loading for performance
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")
    private TransactionCategory category;

    // Constructors

    public Transaction() {
        this.isCategorizedByUser = false;
        this.isRecurring = false;
        this.isInternalTransfer = false;
    }

    public Transaction(String externalTransactionId, String description, BigDecimal amount, LocalDate transactionDate) {
        this();
        this.id = externalTransactionId; // Use external ID as primary key
        this.externalTransactionId = externalTransactionId;
        this.description = description;
        this.amount = amount;
        this.transactionDate = transactionDate;
        this.direction = amount.compareTo(BigDecimal.ZERO) >= 0 ? TransactionDirection.CREDIT : TransactionDirection.DEBIT;
    }

    // Business Methods

    /**
     * Returns the absolute amount of the transaction
     */
    public BigDecimal getAbsoluteAmount() {
        return amount.abs();
    }

    /**
     * Checks if this is an expense (negative amount)
     */
    public boolean isExpense() {
        return amount.compareTo(BigDecimal.ZERO) < 0;
    }

    /**
     * Checks if this is income (positive amount)
     */
    public boolean isIncome() {
        return amount.compareTo(BigDecimal.ZERO) > 0;
    }

    /**
     * Returns the effective category name for display
     */
    public String getEffectiveCategoryName() {
        if (category != null) {
            return category.getName();
        }
        if (aiSuggestedCategory != null) {
            return aiSuggestedCategory;
        }
        if (originalCategory != null) {
            return originalCategory;
        }
        return "Uncategorized";
    }

    /**
     * Updates the category and marks as user-categorized
     */
    public void setCategoryByUser(TransactionCategory category) {
        this.category = category;
        this.isCategorizedByUser = true;
        this.lastCategorizedAt = ZonedDateTime.now();
    }

    /**
     * Sets AI-suggested category with confidence score
     */
    public void setAiCategory(String categoryName, BigDecimal confidence) {
        this.aiSuggestedCategory = categoryName;
        this.confidenceScore = confidence;
        this.lastCategorizedAt = ZonedDateTime.now();
    }

    /**
     * Returns a short description for display (truncated if too long)
     */
    public String getShortDescription() {
        if (description == null) return "Unknown Transaction";
        return description.length() > 50 ? description.substring(0, 47) + "..." : description;
    }

    // Enums

    public enum TransactionType {
        PAYMENT,
        TRANSFER,
        DIRECT_DEBIT,
        DIRECT_CREDIT,
        ATM_WITHDRAWAL,
        INTEREST,
        FEE,
        OTHER
    }

    public enum TransactionDirection {
        DEBIT,  // Money going out (negative)
        CREDIT  // Money coming in (positive)
    }
}
