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
 * BillPayment entity for tracking individual bill payments.
 * 
 * Maintains payment history and links to transactions when available.
 * 
 * @author Finsplore Team
 */
@Entity
@Table(name = "bill_payments", indexes = {
    @Index(name = "idx_payment_bill_id", columnList = "bill_id"),
    @Index(name = "idx_payment_date", columnList = "payment_date"),
    @Index(name = "idx_payment_status", columnList = "payment_status")
})
@Getter
@Setter
@ToString(exclude = {"bill", "transaction"})
@EqualsAndHashCode(of = "id")
public class BillPayment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Payment Information
    @Column(name = "amount_paid", precision = 15, scale = 2, nullable = false)
    private BigDecimal amountPaid;

    @Column(name = "payment_date", nullable = false)
    private LocalDate paymentDate;

    @Column(name = "due_date")
    private LocalDate dueDate; // The original due date for this payment

    @Enumerated(EnumType.STRING)
    @Column(name = "payment_status", nullable = false)
    private PaymentStatus paymentStatus = PaymentStatus.COMPLETED;

    @Enumerated(EnumType.STRING)
    @Column(name = "payment_method")
    private PaymentMethod paymentMethod;

    // Additional Details
    @Column(name = "reference_number", length = 100)
    private String referenceNumber;

    @Column(name = "confirmation_number", length = 100)
    private String confirmationNumber;

    @Column(name = "notes", length = 500)
    private String notes;

    // Status Tracking
    @Column(name = "is_late_payment", nullable = false)
    private Boolean isLatePayment = false;

    @Column(name = "late_fee_amount", precision = 15, scale = 2)
    private BigDecimal lateFeeAmount;

    @Column(name = "discount_amount", precision = 15, scale = 2)
    private BigDecimal discountAmount;

    // Audit Fields
    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private ZonedDateTime createdAt;

    // Relationships

    /**
     * The bill this payment belongs to
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "bill_id", nullable = false)
    private Bill bill;

    /**
     * Associated transaction (if payment was made through linked bank account)
     */
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "transaction_id")
    private Transaction transaction;

    // Constructors

    public BillPayment() {
        this.paymentStatus = PaymentStatus.COMPLETED;
        this.isLatePayment = false;
    }

    public BillPayment(Bill bill, BigDecimal amountPaid, LocalDate paymentDate) {
        this();
        this.bill = bill;
        this.amountPaid = amountPaid;
        this.paymentDate = paymentDate;
        this.dueDate = bill.getNextDueDate();
        this.isLatePayment = paymentDate.isAfter(this.dueDate);
    }

    // Business Methods

    /**
     * Checks if this payment was made on time
     */
    public boolean isOnTime() {
        return !isLatePayment && (dueDate == null || !paymentDate.isAfter(dueDate));
    }

    /**
     * Calculates days late (positive) or early (negative)
     */
    public long getDaysFromDueDate() {
        if (dueDate == null) return 0;
        return dueDate.until(paymentDate).getDays();
    }

    /**
     * Gets the total amount including fees and discounts
     */
    public BigDecimal getTotalAmount() {
        BigDecimal total = amountPaid;
        if (lateFeeAmount != null) {
            total = total.add(lateFeeAmount);
        }
        if (discountAmount != null) {
            total = total.subtract(discountAmount);
        }
        return total;
    }

    /**
     * Links this payment to a transaction
     */
    public void linkToTransaction(Transaction transaction) {
        this.transaction = transaction;
    }

    /**
     * Adds a late fee to this payment
     */
    public void addLateFee(BigDecimal feeAmount) {
        this.lateFeeAmount = feeAmount;
        this.isLatePayment = true;
    }

    /**
     * Applies a discount to this payment
     */
    public void applyDiscount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
    }

    // Enums

    public enum PaymentStatus {
        PENDING("Pending"),
        COMPLETED("Completed"),
        FAILED("Failed"),
        CANCELLED("Cancelled"),
        REFUNDED("Refunded");

        private final String displayName;

        PaymentStatus(String displayName) {
            this.displayName = displayName;
        }

        public String getDisplayName() {
            return displayName;
        }
    }

    public enum PaymentMethod {
        BANK_TRANSFER("Bank Transfer"),
        CREDIT_CARD("Credit Card"),
        DEBIT_CARD("Debit Card"),
        DIRECT_DEBIT("Direct Debit"),
        CASH("Cash"),
        CHECK("Check"),
        ONLINE_PAYMENT("Online Payment"),
        MOBILE_PAYMENT("Mobile Payment"),
        OTHER("Other");

        private final String displayName;

        PaymentMethod(String displayName) {
            this.displayName = displayName;
        }

        public String getDisplayName() {
            return displayName;
        }
    }
}
