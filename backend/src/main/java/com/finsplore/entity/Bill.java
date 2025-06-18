package com.finsplore.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.EqualsAndHashCode;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Bill entity for tracking recurring bills and payments.
 * 
 * Supports various billing frequencies and automatic reminders.
 * Designed for scalability with proper indexing.
 * 
 * @author Finsplore Team
 */
@Entity
@Table(name = "bills", indexes = {
    @Index(name = "idx_bill_user_id", columnList = "user_id"),
    @Index(name = "idx_bill_due_date", columnList = "next_due_date"),
    @Index(name = "idx_bill_status", columnList = "status"),
    @Index(name = "idx_bill_user_due", columnList = "user_id, next_due_date")
})
@Getter
@Setter
@ToString(exclude = {"user", "payments"})
@EqualsAndHashCode(of = "id")
public class Bill {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Bill Information
    @Column(name = "name", nullable = false, length = 200)
    private String name;

    @Column(name = "description", length = 500)
    private String description;

    @Column(name = "amount", precision = 15, scale = 2, nullable = false)
    private BigDecimal amount;

    @Column(name = "currency", length = 3)
    private String currency = "AUD";

    // Billing Schedule
    @Enumerated(EnumType.STRING)
    @Column(name = "frequency", nullable = false)
    private BillFrequency frequency;

    @Column(name = "next_due_date", nullable = false)
    private LocalDate nextDueDate;

    @Column(name = "first_due_date")
    private LocalDate firstDueDate;

    @Column(name = "final_due_date")
    private LocalDate finalDueDate; // For bills with end dates

    // Bill Details
    @Column(name = "company_name", length = 200)
    private String companyName;

    @Column(name = "account_number", length = 100)
    private String accountNumber;

    @Column(name = "reference_number", length = 100)
    private String referenceNumber;

    @Column(name = "website_url", length = 500)
    private String websiteUrl;

    // Status and Settings
    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private BillStatus status = BillStatus.ACTIVE;

    @Column(name = "is_auto_pay_enabled", nullable = false)
    private Boolean isAutoPayEnabled = false;

    @Column(name = "reminder_days_before")
    private Integer reminderDaysBefore = 3; // Default 3 days before due date

    @Column(name = "is_reminder_enabled", nullable = false)
    private Boolean isReminderEnabled = true;

    // Amount Tracking
    @Column(name = "is_fixed_amount", nullable = false)
    private Boolean isFixedAmount = true;

    @Column(name = "estimated_amount", precision = 15, scale = 2)
    private BigDecimal estimatedAmount; // For variable bills

    @Column(name = "last_paid_amount", precision = 15, scale = 2)
    private BigDecimal lastPaidAmount;

    @Column(name = "last_paid_date")
    private LocalDate lastPaidDate;

    // Categories and Tags
    @Column(name = "bill_category", length = 100)
    private String billCategory; // e.g., "Utilities", "Insurance", "Subscription"

    @Column(name = "tags", length = 500)
    private String tags; // Comma-separated tags for organization

    // Audit Fields
    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private ZonedDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private ZonedDateTime updatedAt;

    @Column(name = "last_reminder_sent")
    private ZonedDateTime lastReminderSent;

    // Relationships

    /**
     * User who owns this bill
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    /**
     * Category this bill belongs to
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")
    private TransactionCategory category;

    /**
     * Payment history for this bill
     */
    @OneToMany(mappedBy = "bill", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<BillPayment> payments = new ArrayList<>();

    // Constructors

    public Bill() {
        this.status = BillStatus.ACTIVE;
        this.isAutoPayEnabled = false;
        this.isReminderEnabled = true;
        this.isFixedAmount = true;
        this.reminderDaysBefore = 3;
        this.currency = "AUD";
    }

    public Bill(String name, BigDecimal amount, BillFrequency frequency, LocalDate firstDueDate, User user) {
        this();
        this.name = name;
        this.amount = amount;
        this.frequency = frequency;
        this.firstDueDate = firstDueDate;
        this.nextDueDate = firstDueDate;
        this.user = user;
    }

    // Business Methods

    /**
     * Calculates the next due date based on frequency
     */
    public LocalDate calculateNextDueDate() {
        if (nextDueDate == null) return firstDueDate;
        
        return switch (frequency) {
            case WEEKLY -> nextDueDate.plusWeeks(1);
            case BIWEEKLY -> nextDueDate.plusWeeks(2);
            case MONTHLY -> nextDueDate.plusMonths(1);
            case BIMONTHLY -> nextDueDate.plusMonths(2);
            case QUARTERLY -> nextDueDate.plusMonths(3);
            case SEMI_ANNUALLY -> nextDueDate.plusMonths(6);
            case ANNUALLY -> nextDueDate.plusYears(1);
            case DAILY -> nextDueDate.plusDays(1);
        };
    }

    /**
     * Advances the bill to the next due date
     */
    public void advanceToNextDue() {
        this.nextDueDate = calculateNextDueDate();
        this.updatedAt = ZonedDateTime.now();
    }

    /**
     * Checks if the bill is overdue
     */
    public boolean isOverdue() {
        return nextDueDate.isBefore(LocalDate.now());
    }

    /**
     * Checks if the bill is due soon (within reminder days)
     */
    public boolean isDueSoon() {
        LocalDate reminderDate = LocalDate.now().plusDays(reminderDaysBefore);
        return !nextDueDate.isAfter(reminderDate);
    }

    /**
     * Gets the number of days until due date
     */
    public long getDaysUntilDue() {
        return LocalDate.now().until(nextDueDate).getDays();
    }

    /**
     * Records a payment for this bill
     */
    public BillPayment recordPayment(BigDecimal paidAmount, LocalDate paymentDate) {
        BillPayment payment = new BillPayment(this, paidAmount, paymentDate);
        payments.add(payment);
        
        this.lastPaidAmount = paidAmount;
        this.lastPaidDate = paymentDate;
        this.advanceToNextDue();
        
        return payment;
    }

    /**
     * Gets the effective amount (fixed or estimated)
     */
    public BigDecimal getEffectiveAmount() {
        if (isFixedAmount) {
            return amount;
        }
        return estimatedAmount != null ? estimatedAmount : amount;
    }

    /**
     * Updates the reminder settings
     */
    public void updateReminderSettings(boolean enabled, int daysBefore) {
        this.isReminderEnabled = enabled;
        this.reminderDaysBefore = daysBefore;
        this.updatedAt = ZonedDateTime.now();
    }

    /**
     * Marks reminder as sent
     */
    public void markReminderSent() {
        this.lastReminderSent = ZonedDateTime.now();
    }

    /**
     * Pauses the bill (sets status to PAUSED)
     */
    public void pause() {
        this.status = BillStatus.PAUSED;
        this.updatedAt = ZonedDateTime.now();
    }

    /**
     * Resumes the bill (sets status to ACTIVE)
     */
    public void resume() {
        this.status = BillStatus.ACTIVE;
        this.updatedAt = ZonedDateTime.now();
    }

    /**
     * Archives the bill (sets status to ARCHIVED)
     */
    public void archive() {
        this.status = BillStatus.ARCHIVED;
        this.updatedAt = ZonedDateTime.now();
    }

    // Enums

    public enum BillFrequency {
        DAILY("Daily"),
        WEEKLY("Weekly"),
        BIWEEKLY("Bi-weekly"),
        MONTHLY("Monthly"),
        BIMONTHLY("Bi-monthly"),
        QUARTERLY("Quarterly"),
        SEMI_ANNUALLY("Semi-annually"),
        ANNUALLY("Annually");

        private final String displayName;

        BillFrequency(String displayName) {
            this.displayName = displayName;
        }

        public String getDisplayName() {
            return displayName;
        }
    }

    public enum BillStatus {
        ACTIVE("Active"),
        PAUSED("Paused"),
        ARCHIVED("Archived"),
        COMPLETED("Completed");

        private final String displayName;

        BillStatus(String displayName) {
            this.displayName = displayName;
        }

        public String getDisplayName() {
            return displayName;
        }
    }
}
