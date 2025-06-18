package com.finsplore.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.EqualsAndHashCode;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Core User entity for the Finsplore application.
 * 
 * Combines the best aspects of both RedBack and BlueRing implementations:
 * - RedBack's clean structure and relationships
 * - BlueRing's comprehensive financial features
 * 
 * Designed for scalability to handle thousands of users with proper indexing
 * and optimized relationships.
 * 
 * @author Finsplore Team
 */
@Entity
@Table(name = "users", indexes = {
    @Index(name = "idx_user_email", columnList = "email"),
    @Index(name = "idx_user_basiq_id", columnList = "basiq_user_id"),
    @Index(name = "idx_user_created_at", columnList = "created_at")
})
@Getter
@Setter
@ToString(exclude = {"transactions", "bills", "categories", "financialGoals", "suggestions"})
@EqualsAndHashCode(of = "id")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Core Authentication Fields
    @Column(name = "email", unique = true, nullable = false, length = 320)
    private String email;

    @Column(name = "password_hash", nullable = false)
    private String passwordHash;

    // Personal Information
    @Column(name = "first_name", length = 100)
    private String firstName;

    @Column(name = "middle_name", length = 100)
    private String middleName;

    @Column(name = "last_name", length = 100)
    private String lastName;

    @Column(name = "mobile_number", length = 20)
    private String mobileNumber;

    @Column(name = "username", length = 50)
    private String username;

    // External Service Integration
    @Column(name = "basiq_user_id", unique = true, length = 100)
    private String basiqUserId;

    @Column(name = "avatar_url", length = 500)
    private String avatarUrl;

    // Financial Information (from BlueRing)
    @Column(name = "monthly_budget", precision = 15, scale = 2)
    private BigDecimal monthlyBudget;

    @Column(name = "savings_goal", precision = 15, scale = 2)
    private BigDecimal savingsGoal;

    // Account Status and Verification
    @Column(name = "is_email_verified", nullable = false)
    private Boolean isEmailVerified = false;

    @Column(name = "is_active", nullable = false)
    private Boolean isActive = true;

    @Column(name = "email_verified_at")
    private ZonedDateTime emailVerifiedAt;

    // Audit Fields
    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private ZonedDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private ZonedDateTime updatedAt;

    @Column(name = "last_login_at")
    private ZonedDateTime lastLoginAt;

    // Relationship Mappings
    
    /**
     * User's financial transactions
     * Lazy loading for performance with thousands of transactions
     */
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Transaction> transactions = new ArrayList<>();

    /**
     * User's bills and recurring payments
     */
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Bill> bills = new ArrayList<>();

    /**
     * User's custom transaction categories
     */
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<TransactionCategory> categories = new ArrayList<>();

    /**
     * User's financial goals
     */
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<FinancialGoal> financialGoals = new ArrayList<>();

    /**
     * AI-generated financial suggestions for the user
     */
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<FinancialSuggestion> suggestions = new ArrayList<>();

    // Constructors

    public User() {
        this.isEmailVerified = false;
        this.isActive = true;
    }

    public User(String email, String passwordHash) {
        this();
        this.email = email;
        this.passwordHash = passwordHash;
    }

    public User(String email, String passwordHash, String firstName, String lastName) {
        this(email, passwordHash);
        this.firstName = firstName;
        this.lastName = lastName;
    }

    // Business Methods

    /**
     * Returns the user's full name
     */
    public String getFullName() {
        StringBuilder fullName = new StringBuilder();
        if (firstName != null) {
            fullName.append(firstName);
        }
        if (middleName != null && !middleName.trim().isEmpty()) {
            if (fullName.length() > 0) fullName.append(" ");
            fullName.append(middleName);
        }
        if (lastName != null) {
            if (fullName.length() > 0) fullName.append(" ");
            fullName.append(lastName);
        }
        return fullName.toString().trim();
    }

    /**
     * Returns display name for the user (username or first name or email)
     */
    public String getDisplayName() {
        if (username != null && !username.trim().isEmpty()) {
            return username;
        }
        if (firstName != null && !firstName.trim().isEmpty()) {
            return firstName;
        }
        return email;
    }

    /**
     * Marks email as verified
     */
    public void verifyEmail() {
        this.isEmailVerified = true;
        this.emailVerifiedAt = ZonedDateTime.now();
    }

    /**
     * Updates last login timestamp
     */
    public void updateLastLogin() {
        this.lastLoginAt = ZonedDateTime.now();
    }

    /**
     * Checks if user has completed basic profile setup
     */
    public boolean isProfileComplete() {
        return firstName != null && lastName != null && mobileNumber != null;
    }

    /**
     * Adds a transaction to the user's transaction list
     */
    public void addTransaction(Transaction transaction) {
        transactions.add(transaction);
        transaction.setUser(this);
    }

    /**
     * Adds a bill to the user's bill list
     */
    public void addBill(Bill bill) {
        bills.add(bill);
        bill.setUser(this);
    }

    /**
     * Adds a category to the user's category list
     */
    public void addCategory(TransactionCategory category) {
        categories.add(category);
        category.setUser(this);
    }

    /**
     * Adds a financial goal to the user's goals list
     */
    public void addFinancialGoal(FinancialGoal goal) {
        financialGoals.add(goal);
        goal.setUser(this);
    }
}
