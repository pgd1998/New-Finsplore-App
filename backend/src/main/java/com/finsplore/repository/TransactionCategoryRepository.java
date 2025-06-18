package com.finsplore.repository;

import com.finsplore.entity.TransactionCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository interface for TransactionCategory entity operations.
 * 
 * @author Finsplore Team
 */
@Repository
public interface TransactionCategoryRepository extends JpaRepository<TransactionCategory, Long> {

    /**
     * Finds categories by user ID
     */
    List<TransactionCategory> findByUserIdAndIsActiveTrueOrderBySortOrderAscNameAsc(Long userId);

    /**
     * Finds system categories (available to all users)
     */
    @Query("SELECT c FROM TransactionCategory c WHERE c.user IS NULL AND c.isDefault = true AND c.isActive = true ORDER BY c.sortOrder ASC, c.name ASC")
    List<TransactionCategory> findSystemCategories();

    /**
     * Finds category by name for a user
     */
    @Query("SELECT c FROM TransactionCategory c WHERE (c.user.id = :userId OR c.user IS NULL) AND LOWER(c.name) = LOWER(:name) AND c.isActive = true")
    Optional<TransactionCategory> findByUserIdAndName(@Param("userId") Long userId, @Param("name") String name);

    /**
     * Finds categories with budget enabled
     */
    @Query("SELECT c FROM TransactionCategory c WHERE c.user.id = :userId AND c.isBudgetEnabled = true AND c.isActive = true")
    List<TransactionCategory> findBudgetEnabledCategoriesByUserId(@Param("userId") Long userId);
}
