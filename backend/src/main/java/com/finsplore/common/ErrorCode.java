package com.finsplore.common;

/**
 * Business error code definitions for the Finsplore application.
 * These codes are used in ApiResponse to provide consistent error handling.
 * 
 * Note: These are NOT HTTP status codes - they are application-specific error codes.
 * 
 * @author Finsplore Team
 */
public class ErrorCode {

    // ========== Success ==========
    public static final int SUCCESS = 0;
    
    // ========== Parameter Errors (1xxx) ==========
    public static final int PARAM_INVALID = 1001;              // Validation failed (e.g., empty or malformed input)
    public static final int PARAM_MISSING = 1002;              // Required parameter is missing
    public static final int PARAM_TYPE_MISMATCH = 1003;        // Wrong data type
    public static final int REQUEST_METHOD_NOT_SUPPORTED = 1004; // HTTP method not allowed

    // Financial-specific validation errors
    public static final int INVALID_TRANSACTION_FORMAT = 1010;    // Transaction missing required fields
    public static final int INVALID_TRANSACTION_DIRECTION = 1011; // Transaction direction invalid
    public static final int INVALID_AMOUNT = 1012;                // Amount is negative or zero when positive required
    public static final int INVALID_DATE_FORMAT = 1013;           // Date format is incorrect
    public static final int INVALID_CATEGORY = 1014;              // Transaction category is invalid
    
    // ========== Authentication & Authorization (2xxx) ==========
    public static final int UNAUTHORIZED = 2001;               // Not logged in
    public static final int TOKEN_EXPIRED = 2002;              // JWT or token expired
    public static final int FORBIDDEN = 2003;                  // Insufficient permissions
    public static final int LOGIN_FAILED = 2004;               // Login failed (e.g., invalid credentials)
    public static final int USER_NOT_FOUND = 2005;             // User does not exist
    public static final int ACCOUNT_DISABLED = 2006;           // Account is locked or disabled
    public static final int INVALID_TOKEN = 2007;              // JWT token is malformed or invalid
    public static final int EMAIL_NOT_VERIFIED = 2008;         // Email verification required
    
    // ========== Resource Errors (3xxx) ==========
    public static final int RESOURCE_NOT_FOUND = 3001;         // Generic resource not found
    public static final int RESOURCE_ALREADY_EXISTS = 3002;    // Resource already exists (e.g., duplicate email)
    public static final int RESOURCE_STATE_INVALID = 3003;     // Resource exists but in invalid state
    public static final int DUPLICATE_OPERATION = 3004;        // Repeated operation not allowed
    
    // Financial-specific resource errors
    public static final int ACCOUNT_NOT_FOUND = 3010;          // Bank account not found
    public static final int TRANSACTION_NOT_FOUND = 3011;      // Transaction not found
    public static final int BILL_NOT_FOUND = 3012;             // Bill not found
    public static final int BUDGET_NOT_FOUND = 3013;           // Budget not found
    public static final int GOAL_NOT_FOUND = 3014;             // Financial goal not found
    
    // ========== Business Logic Errors (4xxx) ==========
    public static final int BUSINESS_RULE_VIOLATION = 4001;    // Operation violates business rule
    public static final int OPERATION_NOT_ALLOWED = 4002;      // Operation not allowed in current context
    public static final int RATE_LIMIT_EXCEEDED = 4003;        // Too many requests
    public static final int INSUFFICIENT_BALANCE = 4004;       // Account balance insufficient
    public static final int BUDGET_EXCEEDED = 4005;            // Budget limit exceeded
    public static final int GOAL_ALREADY_ACHIEVED = 4006;      // Financial goal already met
    
    // ========== Third-Party Service Errors (4xxx) ==========
    public static final int BASIQ_API_ERROR = 4100;            // Basiq API error
    public static final int BASIQ_USER_NOT_FOUND = 4101;       // Basiq user not found
    public static final int BASIQ_ACCOUNT_LINK_FAILED = 4102;  // Failed to link bank account via Basiq
    public static final int OPENAI_API_ERROR = 4200;           // OpenAI API error
    public static final int EMAIL_SERVICE_ERROR = 4300;        // Email service error
    
    // ========== System Errors (5xxx) ==========
    public static final int SYSTEM_ERROR = 5000;               // Generic internal server error
    public static final int DATABASE_ERROR = 5001;             // Database failure
    public static final int THIRD_PARTY_SERVICE_ERROR = 5002;  // Third-party service call failed
    public static final int NETWORK_ERROR = 5003;              // Timeout, DNS issues, etc.
    public static final int CONFIGURATION_ERROR = 5004;        // Configuration error
    public static final int CACHE_ERROR = 5005;                // Redis/cache error

    // Private constructor to prevent instantiation
    private ErrorCode() {
        throw new UnsupportedOperationException("ErrorCode is a utility class and cannot be instantiated");
    }
}
