package com.finsplore.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.EqualsAndHashCode;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.time.temporal.ChronoUnit;

/**
 * FinancialGoal entity for tracking user financial goals and savings targets.
 * 
 * Supports various goal types with progress tracking and milestone management.
 * 
 * @author Finsplore Team
 */
@Entity
@Table(name = "financial_goals", indexes = {
    @Index(name = "idx_goal_user_id", columnList = "user_id"),
    @Index(name = "idx_goal_status", columnList = "goal_status"),
    @Index(name = "idx_goal_target_date", columnList = "target_date"),
    @Index(name = "idx_goal_type", columnList = "goal_type")
})
@Getter
@Setter
@ToString(exclude = {"user"})
@EqualsAndHashCode(of = "id")
public class FinancialGoal {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Goal Information
    @Column(name = "name", nullable = false, length = 200)
    private String name;

    @Column(name = "description", length = 1000)
    private String description;

    @Enumerated(EnumType.STRING)
    @Column(name = "goal_type", nullable = false)
    private GoalType goalType;

    // Financial Targets
    @Column(name = "target_amount", precision = 15, scale = 2, nullable = false)
    private BigDecimal targetAmount;

    @Column(name = "current_amount", precision = 15, scale = 2, nullable = false)
    private BigDecimal currentAmount = BigDecimal.ZERO;

    @Column(name = "monthly_contribution", precision = 15, scale = 2)
    private BigDecimal monthlyContribution;

    @Column(name = "currency", length = 3)
    private String currency = "AUD";

    // Timeline
    @Column(name = "start_date", nullable = false)
    private LocalDate startDate;

    @Column(name = "target_date")
    private LocalDate targetDate;

    @Column(name = "achieved_date")
    private LocalDate achievedDate;

    // Status and Progress
    @Enumerated(EnumType.STRING)
    @Column(name = "goal_status", nullable = false)
    private GoalStatus goalStatus = GoalStatus.ACTIVE;

    @Enumerated(EnumType.STRING)
    @Column(name = "priority_level", nullable = false)
    private PriorityLevel priorityLevel = PriorityLevel.MEDIUM;

    @Column(name = "progress_percentage", precision = 5, scale = 2)
    private BigDecimal progressPercentage = BigDecimal.ZERO;

    // Settings and Preferences
    @Column(name = "is_automatic_contribution", nullable = false)
    private Boolean isAutomaticContribution = false;

    @Column(name = "reminder_frequency")
    @Enumerated(EnumType.STRING)
    private ReminderFrequency reminderFrequency = ReminderFrequency.MONTHLY;

    @Column(name = "is_reminder_enabled", nullable = false)
    private Boolean isReminderEnabled = true;

    // Visual and Organization
    @Column(name = "color_hex", length = 7)
    private String colorHex;

    @Column(name = "icon_name", length = 50)
    private String iconName;

    @Column(name = "category", length = 100)
    private String category; // e.g., "Emergency Fund", "Vacation", "Home"

    // Motivation and Notes
    @Column(name = "motivation_note", length = 1000)
    private String motivationNote;

    @Column(name = "celebration_message", length = 500)
    private String celebrationMessage;

    // Analytics
    @Column(name = "total_contributions", precision = 15, scale = 2)
    private BigDecimal totalContributions = BigDecimal.ZERO;

    @Column(name = "last_contribution_date")
    private LocalDate lastContributionDate;

    @Column(name = "last_contribution_amount", precision = 15, scale = 2)
    private BigDecimal lastContributionAmount;

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
     * User who owns this goal
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    /**
     * Associated savings category for automatic tracking
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "savings_category_id")
    private TransactionCategory savingsCategory;

    // Constructors

    public FinancialGoal() {
        this.currentAmount = BigDecimal.ZERO;
        this.totalContributions = BigDecimal.ZERO;
        this.progressPercentage = BigDecimal.ZERO;
        this.goalStatus = GoalStatus.ACTIVE;
        this.priorityLevel = PriorityLevel.MEDIUM;
        this.isAutomaticContribution = false;
        this.isReminderEnabled = true;
        this.reminderFrequency = ReminderFrequency.MONTHLY;
        this.currency = "AUD";
        this.startDate = LocalDate.now();
    }

    public FinancialGoal(String name, BigDecimal targetAmount, GoalType goalType, User user) {
        this();
        this.name = name;
        this.targetAmount = targetAmount;
        this.goalType = goalType;
        this.user = user;
    }

    // Business Methods

    /**
     * Calculates and updates the progress percentage
     */
    public void updateProgress() {
        if (targetAmount.compareTo(BigDecimal.ZERO) <= 0) {
            this.progressPercentage = BigDecimal.ZERO;
            return;
        }

        BigDecimal progress = currentAmount
                .divide(targetAmount, 4, RoundingMode.HALF_UP)
                .multiply(new BigDecimal("100"));

        // Cap at 100%
        this.progressPercentage = progress.min(new BigDecimal("100"));

        // Check if goal is achieved
        if (progress.compareTo(new BigDecimal("100")) >= 0 && goalStatus == GoalStatus.ACTIVE) {
            this.goalStatus = GoalStatus.ACHIEVED;
            this.achievedDate = LocalDate.now();
        }
    }

    /**
     * Adds a contribution to the goal
     */
    public void addContribution(BigDecimal amount) {
        this.currentAmount = this.currentAmount.add(amount);
        this.totalContributions = this.totalContributions.add(amount);
        this.lastContributionAmount = amount;
        this.lastContributionDate = LocalDate.now();
        updateProgress();
    }

    /**
     * Calculates remaining amount to reach the goal
     */
    public BigDecimal getRemainingAmount() {
        BigDecimal remaining = targetAmount.subtract(currentAmount);
        return remaining.max(BigDecimal.ZERO);
    }

    /**
     * Calculates days remaining until target date
     */
    public long getDaysRemaining() {
        if (targetDate == null) return -1;
        return ChronoUnit.DAYS.between(LocalDate.now(), targetDate);
    }

    /**
     * Calculates required monthly contribution to reach goal by target date
     */
    public BigDecimal getRequiredMonthlyContribution() {
        if (targetDate == null) return BigDecimal.ZERO;
        
        long monthsRemaining = ChronoUnit.MONTHS.between(LocalDate.now(), targetDate);
        if (monthsRemaining <= 0) return getRemainingAmount();
        
        return getRemainingAmount().divide(BigDecimal.valueOf(monthsRemaining), 2, RoundingMode.HALF_UP);
    }

    /**
     * Checks if the goal is on track based on time elapsed and progress
     */
    public boolean isOnTrack() {
        if (targetDate == null) return true;
        
        long totalDays = ChronoUnit.DAYS.between(startDate, targetDate);
        long elapsedDays = ChronoUnit.DAYS.between(startDate, LocalDate.now());
        
        if (totalDays <= 0) return true;
        
        BigDecimal expectedProgress = BigDecimal.valueOf(elapsedDays)
                .divide(BigDecimal.valueOf(totalDays), 4, RoundingMode.HALF_UP)
                .multiply(new BigDecimal("100"));
        
        return progressPercentage.compareTo(expectedProgress) >= 0;
    }

    /**
     * Calculates the success rate (useful for motivation)
     */
    public String getSuccessRate() {
        if (getDaysRemaining() < 0) {
            return goalStatus == GoalStatus.ACHIEVED ? "Goal Achieved!" : "Goal Overdue";
        }
        
        if (isOnTrack()) {
            return "On Track";
        } else {
            return "Behind Schedule";
        }
    }

    /**
     * Pauses the goal
     */
    public void pause() {
        this.goalStatus = GoalStatus.PAUSED;
    }

    /**
     * Resumes the goal
     */
    public void resume() {
        this.goalStatus = GoalStatus.ACTIVE;
    }

    /**
     * Archives the goal
     */
    public void archive() {
        this.goalStatus = GoalStatus.ARCHIVED;
    }

    /**
     * Marks reminder as sent
     */
    public void markReminderSent() {
        this.lastReminderSent = ZonedDateTime.now();
    }

    // Enums

    public enum GoalType {
        EMERGENCY_FUND("Emergency Fund"),
        VACATION("Vacation"),
        HOME_PURCHASE("Home Purchase"),
        DEBT_PAYOFF("Debt Payoff"),
        RETIREMENT("Retirement"),
        EDUCATION("Education"),
        INVESTMENT("Investment"),
        VEHICLE("Vehicle"),
        WEDDING("Wedding"),
        GENERAL_SAVINGS("General Savings"),
        OTHER("Other");

        private final String displayName;

        GoalType(String displayName) {
            this.displayName = displayName;
        }

        public String getDisplayName() {
            return displayName;
        }
    }

    public enum GoalStatus {
        ACTIVE("Active"),
        PAUSED("Paused"),
        ACHIEVED("Achieved"),
        ARCHIVED("Archived"),
        CANCELLED("Cancelled");

        private final String displayName;

        GoalStatus(String displayName) {
            this.displayName = displayName;
        }

        public String getDisplayName() {
            return displayName;
        }
    }

    public enum PriorityLevel {
        LOW("Low"),
        MEDIUM("Medium"),
        HIGH("High"),
        CRITICAL("Critical");

        private final String displayName;

        PriorityLevel(String displayName) {
            this.displayName = displayName;
        }

        public String getDisplayName() {
            return displayName;
        }
    }

    public enum ReminderFrequency {
        WEEKLY("Weekly"),
        BIWEEKLY("Bi-weekly"),
        MONTHLY("Monthly"),
        QUARTERLY("Quarterly"),
        NEVER("Never");

        private final String displayName;

        ReminderFrequency(String displayName) {
            this.displayName = displayName;
        }

        public String getDisplayName() {
            return displayName;
        }
    }
}
