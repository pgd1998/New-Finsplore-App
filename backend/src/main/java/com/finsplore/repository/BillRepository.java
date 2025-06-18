package com.finsplore.repository;

import com.finsplore.entity.Bill;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

/**
 * Repository interface for Bill entity operations.
 * 
 * @author Finsplore Team
 */
@Repository
public interface BillRepository extends JpaRepository<Bill, Long> {

    /**
     * Finds bills by user ID and status
     */
    List<Bill> findByUserIdAndStatusOrderByNextDueDateAsc(Long userId, Bill.BillStatus status);

    /**
     * Finds bills due soon for reminders
     */
    @Query("SELECT b FROM Bill b WHERE b.user.id = :userId AND b.status = 'ACTIVE' AND b.isReminderEnabled = true AND b.nextDueDate <= :reminderDate")
    List<Bill> findBillsDueForReminders(@Param("userId") Long userId, @Param("reminderDate") LocalDate reminderDate);

    /**
     * Finds overdue bills
     */
    @Query("SELECT b FROM Bill b WHERE b.user.id = :userId AND b.status = 'ACTIVE' AND b.nextDueDate < :today")
    List<Bill> findOverdueBills(@Param("userId") Long userId, @Param("today") LocalDate today);

    /**
     * Finds bills by category
     */
    List<Bill> findByUserIdAndBillCategoryAndStatusOrderByNextDueDateAsc(Long userId, String category, Bill.BillStatus status);
}
