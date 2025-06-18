package com.finsplore.repository;

import com.finsplore.entity.FinancialGoal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.List;

/**
 * Repository interface for FinancialGoal entity operations.
 * 
 * @author Finsplore Team
 */
@Repository
public interface FinancialGoalRepository extends JpaRepository<FinancialGoal, Long> {

    /**
     * Finds goals by user ID and status
     */
    List<FinancialGoal> findByUserIdAndGoalStatusOrderByPriorityLevelDescCreatedAtDesc(Long userId, FinancialGoal.GoalStatus status);

    /**
     * Finds goals needing reminders
     */
    @Query("SELECT g FROM FinancialGoal g WHERE g.user.id = :userId AND g.goalStatus = 'ACTIVE' AND g.isReminderEnabled = true AND (g.lastReminderSent IS NULL OR g.lastReminderSent < :reminderCutoff)")
    List<FinancialGoal> findGoalsNeedingReminders(@Param("userId") Long userId, @Param("reminderCutoff") ZonedDateTime reminderCutoff);

    /**
     * Finds goals approaching target date
     */
    @Query("SELECT g FROM FinancialGoal g WHERE g.user.id = :userId AND g.goalStatus = 'ACTIVE' AND g.targetDate IS NOT NULL AND g.targetDate <= :nearDate")
    List<FinancialGoal> findGoalsApproachingTargetDate(@Param("userId") Long userId, @Param("nearDate") LocalDate nearDate);

    /**
     * Finds goals by type
     */
    List<FinancialGoal> findByUserIdAndGoalTypeAndGoalStatusOrderByCreatedAtDesc(Long userId, FinancialGoal.GoalType goalType, FinancialGoal.GoalStatus status);
}
