package com.finsplore.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.EqualsAndHashCode;
import org.hibernate.annotations.CreationTimestamp;

import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Transaction Category entity for organizing and analyzing user transactions.
 * 
 * Supports both system-defined and user-defined categories with hierarchical structure.
 * Optimized for scalability with proper indexing.
 * 
 * @author Finsplore Team
 */
@Entity
@Table(name = "transaction_categories", indexes = {
    @Index(name = "idx_category_user_id", columnList = "user_id"),
    @Index(name = "idx_category_name", columnList = "name"),
    @Index(name = "idx_category_type", columnList = "category_type"),
    @Index(name = "idx_category_parent", columnList = "parent_category_id")
})
@Getter
@Setter
@ToString(exclude = {"user", "transactions", "parentCategory", "childCategories"})
@EqualsAndHashCode(of = "id")
public class TransactionCategory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Category Information
    @Column(name = "name", nullable = false, length = 100)
    private String name;

    @Column(name = "description", length = 500)
    private String description;

    @Column(name = "color_hex", length = 7) // For UI display (#FFFFFF format)
    private String colorHex;

    @Column(name = "icon_name", length = 50) // Icon identifier for UI
    private String iconName;

    // Category Type and Hierarchy
    @Enumerated(EnumType.STRING)
    @Column(name = "category_type", nullable = false)
    private CategoryType categoryType;

    @Enumerated(EnumType.STRING)
    @Column(name = "transaction_direction")
    private TransactionDirection transactionDirection; // INCOME, EXPENSE, or BOTH

    // Hierarchical Structure (for subcategories)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_category_id")
    private TransactionCategory parentCategory;

    @OneToMany(mappedBy = "parentCategory", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<TransactionCategory> childCategories = new ArrayList<>();

    // Budget and Goal Settings
    @Column(name = "monthly_budget_limit", precision = 15, scale = 2)
    private BigDecimal monthlyBudgetLimit;

    @Column(name = "is_budget_enabled", nullable = false)
    private Boolean isBudgetEnabled = false;

    // Category Settings
    @Column(name = "is_active", nullable = false)
    private Boolean isActive = true;

    @Column(name = "is_default", nullable = false)
    private Boolean isDefault = false; // True for system-provided categories

    @Column(name = "sort_order")
    private Integer sortOrder = 0;

    // Audit Fields
    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private ZonedDateTime createdAt;

    @Column(name = "updated_at")
    private ZonedDateTime updatedAt;

    // Relationships

    /**
     * User who owns this category (null for system categories)
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    /**
     * Transactions assigned to this category
     */
    @OneToMany(mappedBy = "category", fetch = FetchType.LAZY)
    private List<Transaction> transactions = new ArrayList<>();

    // Constructors

    public TransactionCategory() {
        this.isActive = true;
        this.isDefault = false;
        this.isBudgetEnabled = false;
        this.sortOrder = 0;
    }

    public TransactionCategory(String name, CategoryType categoryType, User user) {
        this();
        this.name = name;
        this.categoryType = categoryType;
        this.user = user;
    }

    public TransactionCategory(String name, CategoryType categoryType, TransactionDirection direction) {
        this();
        this.name = name;
        this.categoryType = categoryType;
        this.transactionDirection = direction;
        this.isDefault = true; // System category
    }

    // Business Methods

    /**
     * Calculates total amount for this category within a date range
     * Note: This should typically be done via repository queries for performance
     */
    public BigDecimal getTotalAmount() {
        return transactions.stream()
                .map(Transaction::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    /**
     * Gets the number of transactions in this category
     */
    public int getTransactionCount() {
        return transactions.size();
    }

    /**
     * Checks if this category has a budget set
     */
    public boolean hasBudget() {
        return isBudgetEnabled && monthlyBudgetLimit != null && monthlyBudgetLimit.compareTo(BigDecimal.ZERO) > 0;
    }

    /**
     * Checks if this is a system-provided category
     */
    public boolean isSystemCategory() {
        return isDefault && user == null;
    }

    /**
     * Checks if this is a user-defined category
     */
    public boolean isUserCategory() {
        return !isDefault && user != null;
    }

    /**
     * Gets the full category path (for subcategories)
     */
    public String getFullCategoryPath() {
        if (parentCategory == null) {
            return name;
        }
        return parentCategory.getFullCategoryPath() + " > " + name;
    }

    /**
     * Adds a child category
     */
    public void addChildCategory(TransactionCategory child) {
        childCategories.add(child);
        child.setParentCategory(this);
    }

    /**
     * Enables budget tracking for this category
     */
    public void enableBudget(BigDecimal monthlyLimit) {
        this.monthlyBudgetLimit = monthlyLimit;
        this.isBudgetEnabled = true;
        this.updatedAt = ZonedDateTime.now();
    }

    /**
     * Disables budget tracking for this category
     */
    public void disableBudget() {
        this.isBudgetEnabled = false;
        this.monthlyBudgetLimit = null;
        this.updatedAt = ZonedDateTime.now();
    }

    /**
     * Updates the category metadata
     */
    public void updateMetadata(String description, String colorHex, String iconName) {
        this.description = description;
        this.colorHex = colorHex;
        this.iconName = iconName;
        this.updatedAt = ZonedDateTime.now();
    }

    // Enums

    public enum CategoryType {
        SYSTEM,     // Predefined system categories
        USER,       // User-created categories
        AI_SUGGESTED // AI-suggested categories that user can adopt
    }

    public enum TransactionDirection {
        INCOME,     // For income categories
        EXPENSE,    // For expense categories
        BOTH        // For categories that can handle both
    }
}
