package com.finsplore.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Data Transfer Object for transaction summary responses.
 * 
 * @author Finsplore Team
 */
@Data
public class TransactionSummaryResponse {

    private LocalDate startDate;
    private LocalDate endDate;
    private BigDecimal totalIncome;
    private BigDecimal totalExpenses;
    private BigDecimal netAmount;
    private Long totalTransactions;
    private Long incomeTransactions;
    private Long expenseTransactions;
    private BigDecimal averageTransactionAmount;
    private BigDecimal largestExpense;
    private BigDecimal largestIncome;

    // Category breakdown
    private String topExpenseCategory;
    private BigDecimal topExpenseCategoryAmount;
    private String topIncomeCategory;
    private BigDecimal topIncomeCategoryAmount;

    // Trends
    private BigDecimal expenseGrowthRate;
    private BigDecimal incomeGrowthRate;

    /**
     * Calculates the savings rate as a percentage
     */
    public BigDecimal getSavingsRate() {
        if (totalIncome == null || totalIncome.compareTo(BigDecimal.ZERO) == 0) {
            return BigDecimal.ZERO;
        }
        return netAmount.divide(totalIncome, 4, BigDecimal.ROUND_HALF_UP)
                .multiply(BigDecimal.valueOf(100));
    }

    /**
     * Returns expense ratio as a percentage of income
     */
    public BigDecimal getExpenseRatio() {
        if (totalIncome == null || totalIncome.compareTo(BigDecimal.ZERO) == 0) {
            return BigDecimal.ZERO;
        }
        return totalExpenses.abs().divide(totalIncome, 4, BigDecimal.ROUND_HALF_UP)
                .multiply(BigDecimal.valueOf(100));
    }
}
