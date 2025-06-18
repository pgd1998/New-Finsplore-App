package com.finsplore.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.EqualsAndHashCode;
import org.hibernate.annotations.CreationTimestamp;

import java.math.BigDecimal;
import java.time.ZonedDateTime;

/**
 * FinancialSuggestion entity for AI-generated financial recommendations.
 * 
 * Stores personalized suggestions based on user spending patterns and goals.
 * 
 * @author Finsplore Team
 */
@Entity
@Table(name = "financial_suggestions", indexes = {
    @Index(name = "idx_suggestion_user_id", columnList = "user_id"),
    @Index(name = "idx_suggestion_type", columnList = "suggestion_type"),
    @Index(name = "idx_suggestion_status", columnList = "status"),
    @Index(name = "idx_suggestion_priority", columnList = "priority_score"),
    @Index(name = "idx_suggestion_created", columnList = "created_at")
})
@Getter
@Setter
@ToString(exclude = {"user"})
@EqualsAndHashCode(of = "id")
public class FinancialSuggestion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Suggestion Content
    @Column(name = "title", nullable = false, length = 200)
    private String title;

    @Column(name = "description", nullable = false, length = 1000)
    private String description;

    @Column(name = "detailed_explanation", length = 2000)
    private String detailedExplanation;

    @Enumerated(EnumType.STRING)
    @Column(name = "suggestion_type", nullable = false)
    private SuggestionType suggestionType;

    // Financial Impact
    @Column(name = "potential_savings", precision = 15, scale = 2)
    private BigDecimal potentialSavings;

    @Column(name = "potential_income", precision = 15, scale = 2)
    private BigDecimal potentialIncome;

    @Column(name = "implementation_cost", precision = 15, scale = 2)
    private BigDecimal implementationCost;

    @Column(name = "monthly_impact", precision = 15, scale = 2)
    private BigDecimal monthlyImpact;

    // AI Analysis Data
    @Column(name = "confidence_score", precision = 3, scale = 2)
    private BigDecimal confidenceScore; // 0.00-1.00

    @Column(name = "priority_score", precision = 3, scale = 2)
    private BigDecimal priorityScore; // 0.00-1.00

    @Column(name = "relevance_score", precision = 3, scale = 2)
    private BigDecimal relevanceScore; // 0.00-1.00

    @Column(name = "ai_model_version", length = 50)
    private String aiModelVersion;

    // Categorization and Context
    @Column(name = "category", length = 100)
    private String category; // e.g., "Spending", "Savings", "Investment", "Budget"

    @Column(name = "related_transaction_category", length = 100)
    private String relatedTransactionCategory;

    @Column(name = "time_horizon", length = 50)
    private String timeHorizon; // e.g., "Immediate", "Short-term", "Long-term"

    // Status and User Interaction
    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private SuggestionStatus status = SuggestionStatus.ACTIVE;

    @Column(name = "is_personalized", nullable = false)
    private Boolean isPersonalized = true;

    @Column(name = "is_actionable", nullable = false)
    private Boolean isActionable = true;

    @Column(name = "view_count", nullable = false)
    private Integer viewCount = 0;

    // User Feedback
    @Enumerated(EnumType.STRING)
    @Column(name = "user_feedback")
    private UserFeedback userFeedback;

    @Column(name = "user_rating")
    private Integer userRating; // 1-5 stars

    @Column(name = "feedback_notes", length = 500)
    private String feedbackNotes;

    @Column(name = "is_implemented", nullable = false)
    private Boolean isImplemented = false;

    @Column(name = "implementation_date")
    private ZonedDateTime implementationDate;

    // Action Items
    @Column(name = "action_steps", length = 2000)
    private String actionSteps; // JSON or structured text

    @Column(name = "suggested_deadline")
    private ZonedDateTime suggestedDeadline;

    @Column(name = "difficulty_level")
    @Enumerated(EnumType.STRING)
    private DifficultyLevel difficultyLevel = DifficultyLevel.MEDIUM;

    // Links and Resources
    @Column(name = "resource_links", length = 1000)
    private String resourceLinks; // JSON array of helpful links

    @Column(name = "related_goals", length = 500)
    private String relatedGoals; // Comma-separated goal IDs

    // Expiration and Relevance
    @Column(name = "expires_at")
    private ZonedDateTime expiresAt;

    @Column(name = "is_time_sensitive", nullable = false)
    private Boolean isTimeSensitive = false;

    // Analytics and Tracking
    @Column(name = "last_viewed_at")
    private ZonedDateTime lastViewedAt;

    @Column(name = "dismissal_count", nullable = false)
    private Integer dismissalCount = 0;

    @Column(name = "last_dismissed_at")
    private ZonedDateTime lastDismissedAt;

    // Audit Fields
    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private ZonedDateTime createdAt;

    @Column(name = "updated_at")
    private ZonedDateTime updatedAt;

    // Relationships

    /**
     * User this suggestion is for
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    /**
     * Related financial goal (if applicable)
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "related_goal_id")
    private FinancialGoal relatedGoal;

    /**
     * Related transaction category (if applicable)
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "related_category_id")
    private TransactionCategory relatedCategory;

    // Constructors

    public FinancialSuggestion() {
        this.status = SuggestionStatus.ACTIVE;
        this.isPersonalized = true;
        this.isActionable = true;
        this.isImplemented = false;
        this.isTimeSensitive = false;
        this.viewCount = 0;
        this.dismissalCount = 0;
        this.difficultyLevel = DifficultyLevel.MEDIUM;
    }

    public FinancialSuggestion(String title, String description, SuggestionType type, User user) {
        this();
        this.title = title;
        this.description = description;
        this.suggestionType = type;
        this.user = user;
    }

    // Business Methods

    /**
     * Records a view of this suggestion
     */
    public void recordView() {
        this.viewCount++;
        this.lastViewedAt = ZonedDateTime.now();
    }

    /**
     * Dismisses the suggestion
     */
    public void dismiss() {
        this.dismissalCount++;
        this.lastDismissedAt = ZonedDateTime.now();
        this.status = SuggestionStatus.DISMISSED;
    }

    /**
     * Marks the suggestion as implemented
     */
    public void markAsImplemented() {
        this.isImplemented = true;
        this.implementationDate = ZonedDateTime.now();
        this.status = SuggestionStatus.IMPLEMENTED;
    }

    /**
     * Sets user feedback
     */
    public void setUserFeedback(UserFeedback feedback, Integer rating, String notes) {
        this.userFeedback = feedback;
        this.userRating = rating;
        this.feedbackNotes = notes;
        this.updatedAt = ZonedDateTime.now();
    }

    /**
     * Checks if the suggestion is expired
     */
    public boolean isExpired() {
        return expiresAt != null && ZonedDateTime.now().isAfter(expiresAt);
    }

    /**
     * Checks if the suggestion is still relevant
     */
    public boolean isRelevant() {
        return status == SuggestionStatus.ACTIVE && !isExpired();
    }

    /**
     * Calculates the overall suggestion score for ranking
     */
    public BigDecimal getOverallScore() {
        BigDecimal base = BigDecimal.ZERO;
        
        if (confidenceScore != null) {
            base = base.add(confidenceScore.multiply(new BigDecimal("0.3")));
        }
        if (priorityScore != null) {
            base = base.add(priorityScore.multiply(new BigDecimal("0.4")));
        }
        if (relevanceScore != null) {
            base = base.add(relevanceScore.multiply(new BigDecimal("0.3")));
        }
        
        return base;
    }

    /**
     * Gets the estimated ROI if both savings and cost are available
     */
    public BigDecimal getEstimatedROI() {
        if (potentialSavings == null || implementationCost == null || 
            implementationCost.compareTo(BigDecimal.ZERO) <= 0) {
            return null;
        }
        
        return potentialSavings.divide(implementationCost, 2, java.math.RoundingMode.HALF_UP);
    }

    /**
     * Archives the suggestion
     */
    public void archive() {
        this.status = SuggestionStatus.ARCHIVED;
        this.updatedAt = ZonedDateTime.now();
    }

    // Enums

    public enum SuggestionType {
        SPENDING_OPTIMIZATION("Spending Optimization"),
        SAVINGS_OPPORTUNITY("Savings Opportunity"),
        BUDGET_ADJUSTMENT("Budget Adjustment"),
        GOAL_RECOMMENDATION("Goal Recommendation"),
        INVESTMENT_ADVICE("Investment Advice"),
        DEBT_MANAGEMENT("Debt Management"),
        SUBSCRIPTION_REVIEW("Subscription Review"),
        BILL_OPTIMIZATION("Bill Optimization"),
        CATEGORY_INSIGHT("Category Insight"),
        TREND_ALERT("Trend Alert"),
        GENERAL_TIP("General Tip");

        private final String displayName;

        SuggestionType(String displayName) {
            this.displayName = displayName;
        }

        public String getDisplayName() {
            return displayName;
        }
    }

    public enum SuggestionStatus {
        ACTIVE("Active"),
        DISMISSED("Dismissed"),
        IMPLEMENTED("Implemented"),
        ARCHIVED("Archived"),
        EXPIRED("Expired");

        private final String displayName;

        SuggestionStatus(String displayName) {
            this.displayName = displayName;
        }

        public String getDisplayName() {
            return displayName;
        }
    }

    public enum UserFeedback {
        VERY_HELPFUL("Very Helpful"),
        HELPFUL("Helpful"),
        NEUTRAL("Neutral"),
        NOT_HELPFUL("Not Helpful"),
        IRRELEVANT("Irrelevant");

        private final String displayName;

        UserFeedback(String displayName) {
            this.displayName = displayName;
        }

        public String getDisplayName() {
            return displayName;
        }
    }

    public enum DifficultyLevel {
        VERY_EASY("Very Easy"),
        EASY("Easy"),
        MEDIUM("Medium"),
        HARD("Hard"),
        VERY_HARD("Very Hard");

        private final String displayName;

        DifficultyLevel(String displayName) {
            this.displayName = displayName;
        }

        public String getDisplayName() {
            return displayName;
        }
    }
}
