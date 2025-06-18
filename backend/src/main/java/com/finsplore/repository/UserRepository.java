package com.finsplore.repository;

import com.finsplore.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.ZonedDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Repository interface for User entity operations.
 * 
 * Provides CRUD operations and custom queries optimized for scalability.
 * Includes methods for authentication, user management, and analytics.
 * 
 * @author Finsplore Team
 */
@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    // Authentication Queries

    /**
     * Finds a user by email address
     */
    Optional<User> findByEmail(String email);

    /**
     * Finds a user by email address (case-insensitive)
     */
    @Query("SELECT u FROM User u WHERE LOWER(u.email) = LOWER(:email)")
    Optional<User> findByEmailIgnoreCase(@Param("email") String email);

    /**
     * Finds a user by Basiq user ID
     */
    Optional<User> findByBasiqUserId(String basiqUserId);

    /**
     * Finds a user by username
     */
    Optional<User> findByUsername(String username);

    // Existence Checks

    /**
     * Checks if a user exists with the given email
     */
    boolean existsByEmail(String email);

    /**
     * Checks if a user exists with the given email (case-insensitive)
     */
    @Query("SELECT COUNT(u) > 0 FROM User u WHERE LOWER(u.email) = LOWER(:email)")
    boolean existsByEmailIgnoreCase(@Param("email") String email);

    /**
     * Checks if a user exists with the given username
     */
    boolean existsByUsername(String username);

    /**
     * Checks if a user exists with the given Basiq user ID
     */
    boolean existsByBasiqUserId(String basiqUserId);

    // User Status Queries

    /**
     * Finds all active users
     */
    List<User> findByIsActiveTrue();

    /**
     * Finds all users with verified emails
     */
    List<User> findByIsEmailVerifiedTrue();

    /**
     * Finds users who haven't verified their email within a time period
     */
    @Query("SELECT u FROM User u WHERE u.isEmailVerified = false AND u.createdAt < :cutoffDate")
    List<User> findUnverifiedUsersOlderThan(@Param("cutoffDate") ZonedDateTime cutoffDate);

    // Profile Completion Queries

    /**
     * Finds users with incomplete profiles
     */
    @Query("SELECT u FROM User u WHERE u.firstName IS NULL OR u.lastName IS NULL OR u.mobileNumber IS NULL")
    List<User> findUsersWithIncompleteProfiles();

    /**
     * Finds users who have completed their basic profile
     */
    @Query("SELECT u FROM User u WHERE u.firstName IS NOT NULL AND u.lastName IS NOT NULL AND u.mobileNumber IS NOT NULL")
    List<User> findUsersWithCompleteProfiles();

    // Financial Data Queries

    /**
     * Finds users who have set up budgets
     */
    @Query("SELECT u FROM User u WHERE u.monthlyBudget IS NOT NULL AND u.monthlyBudget > 0")
    List<User> findUsersWithBudgets();

    /**
     * Finds users who have set savings goals
     */
    @Query("SELECT u FROM User u WHERE u.savingsGoal IS NOT NULL AND u.savingsGoal > 0")
    List<User> findUsersWithSavingsGoals();

    /**
     * Finds users with linked bank accounts (have Basiq user ID)
     */
    @Query("SELECT u FROM User u WHERE u.basiqUserId IS NOT NULL")
    List<User> findUsersWithLinkedBankAccounts();

    // Activity and Engagement Queries

    /**
     * Finds users who logged in recently
     */
    @Query("SELECT u FROM User u WHERE u.lastLoginAt > :since")
    List<User> findUsersLoggedInSince(@Param("since") ZonedDateTime since);

    /**
     * Finds users who haven't logged in for a while
     */
    @Query("SELECT u FROM User u WHERE u.lastLoginAt < :before OR u.lastLoginAt IS NULL")
    List<User> findInactiveUsersSince(@Param("before") ZonedDateTime before);

    /**
     * Finds new users created within a time period
     */
    @Query("SELECT u FROM User u WHERE u.createdAt >= :since")
    List<User> findNewUsersSince(@Param("since") ZonedDateTime since);

    // Search and Analytics Queries

    /**
     * Searches users by name or email (for admin purposes)
     */
    @Query("SELECT u FROM User u WHERE " +
           "LOWER(u.firstName) LIKE LOWER(CONCAT('%', :searchTerm, '%')) OR " +
           "LOWER(u.lastName) LIKE LOWER(CONCAT('%', :searchTerm, '%')) OR " +
           "LOWER(u.email) LIKE LOWER(CONCAT('%', :searchTerm, '%')) OR " +
           "LOWER(u.username) LIKE LOWER(CONCAT('%', :searchTerm, '%'))")
    List<User> searchUsers(@Param("searchTerm") String searchTerm);

    /**
     * Counts users created within a date range
     */
    @Query("SELECT COUNT(u) FROM User u WHERE u.createdAt BETWEEN :startDate AND :endDate")
    Long countUsersCreatedBetween(@Param("startDate") ZonedDateTime startDate, 
                                  @Param("endDate") ZonedDateTime endDate);

    /**
     * Counts active users
     */
    @Query("SELECT COUNT(u) FROM User u WHERE u.isActive = true")
    Long countActiveUsers();

    /**
     * Counts verified users
     */
    @Query("SELECT COUNT(u) FROM User u WHERE u.isEmailVerified = true")
    Long countVerifiedUsers();

    // Update Operations

    /**
     * Updates user's last login timestamp
     */
    @Query("UPDATE User u SET u.lastLoginAt = :loginTime WHERE u.id = :userId")
    void updateLastLoginTime(@Param("userId") Long userId, @Param("loginTime") ZonedDateTime loginTime);

    /**
     * Updates user's email verification status
     */
    @Query("UPDATE User u SET u.isEmailVerified = true, u.emailVerifiedAt = :verifiedAt WHERE u.id = :userId")
    void markEmailAsVerified(@Param("userId") Long userId, @Param("verifiedAt") ZonedDateTime verifiedAt);

    /**
     * Updates user's active status
     */
    @Query("UPDATE User u SET u.isActive = :isActive WHERE u.id = :userId")
    void updateActiveStatus(@Param("userId") Long userId, @Param("isActive") Boolean isActive);

    // Custom Complex Queries

    /**
     * Finds users who might need financial goal reminders
     */
    @Query("SELECT DISTINCT u FROM User u " +
           "JOIN u.financialGoals g " +
           "WHERE g.goalStatus = com.finsplore.entity.FinancialGoal.GoalStatus.ACTIVE " +
           "AND g.isReminderEnabled = true " +
           "AND (g.lastReminderSent IS NULL OR g.lastReminderSent < :reminderCutoff)")
    List<User> findUsersNeedingGoalReminders(@Param("reminderCutoff") ZonedDateTime reminderCutoff);

    /**
     * Finds users who might benefit from AI suggestions
     */
    @Query("SELECT u FROM User u " +
           "WHERE u.isActive = true " +
           "AND SIZE(u.transactions) >= :minTransactions " +
           "AND u.createdAt < :accountAgeCutoff")
    List<User> findUsersEligibleForAISuggestions(@Param("minTransactions") int minTransactions,
                                                 @Param("accountAgeCutoff") ZonedDateTime accountAgeCutoff);

    /**
     * Gets user engagement statistics
     */
    @Query("SELECT " +
           "COUNT(u), " +
           "SUM(CASE WHEN u.isActive = true THEN 1 ELSE 0 END), " +
           "SUM(CASE WHEN u.isEmailVerified = true THEN 1 ELSE 0 END), " +
           "SUM(CASE WHEN u.basiqUserId IS NOT NULL THEN 1 ELSE 0 END) " +
           "FROM User u")
    Object[] getUserEngagementStats();
}
