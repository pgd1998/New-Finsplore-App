package com.finsplore.repository;

import com.finsplore.entity.FinancialSuggestion;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.ZonedDateTime;
import java.util.List;

/**
 * Repository interface for FinancialSuggestion entity operations.
 * 
 * @author Finsplore Team
 */
@Repository
public interface FinancialSuggestionRepository extends JpaRepository<FinancialSuggestion, Long> {

    /**
     * Finds active suggestions for a user, ordered by priority
     */
    @Query("SELECT s FROM FinancialSuggestion s WHERE s.user.id = :userId AND s.status = 'ACTIVE' AND (s.expiresAt IS NULL OR s.expiresAt > CURRENT_TIMESTAMP) ORDER BY s.priorityScore DESC, s.createdAt DESC")
    Page<FinancialSuggestion> findActiveSuggestionsByUserId(@Param("userId") Long userId, Pageable pageable);

    /**
     * Finds suggestions by type for a user
     */
    List<FinancialSuggestion> findByUserIdAndSuggestionTypeAndStatusOrderByPriorityScoreDesc(Long userId, FinancialSuggestion.SuggestionType type, FinancialSuggestion.SuggestionStatus status);

    /**
     * Finds suggestions that need cleanup (old dismissed suggestions)
     */
    @Query("SELECT s FROM FinancialSuggestion s WHERE s.status = 'DISMISSED' AND s.lastDismissedAt < :cutoffDate")
    List<FinancialSuggestion> findOldDismissedSuggestions(@Param("cutoffDate") ZonedDateTime cutoffDate);

    /**
     * Finds expired suggestions that need cleanup
     */
    @Query("SELECT s FROM FinancialSuggestion s WHERE s.expiresAt < CURRENT_TIMESTAMP AND s.status != 'EXPIRED'")
    List<FinancialSuggestion> findExpiredSuggestions();
    
    /**
     * Finds suggestions by user ID ordered by creation date
     */
    List<FinancialSuggestion> findByUserIdOrderByCreatedAtDesc(Long userId);
}
