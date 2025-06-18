package com.finsplore;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.transaction.annotation.EnableTransactionManagement;

/**
 * Main application class for the Finsplore backend service.
 * 
 * Finsplore is a comprehensive financial management platform that helps users:
 * - Track transactions and expenses
 * - Manage budgets and financial goals
 * - Get AI-powered financial insights
 * - Connect securely to bank accounts via Open Banking
 * 
 * @author Finsplore Team
 */
@SpringBootApplication
@EnableCaching
@EnableTransactionManagement
public class FinsploreApplication {

    public static void main(String[] args) {
        SpringApplication.run(FinsploreApplication.class, args);
    }
}
