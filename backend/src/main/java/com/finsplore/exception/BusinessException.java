package com.finsplore.exception;

import lombok.Getter;

/**
 * Custom exception for business logic errors in the Finsplore application.
 * This exception carries both an error code and message for consistent error handling.
 * 
 * @author Finsplore Team
 */
@Getter
public class BusinessException extends RuntimeException {
    private final int code;

    /**
     * Creates a new BusinessException with error code and message
     * 
     * @param code Error code from ErrorCode constants
     * @param message Human-readable error message
     */
    public BusinessException(int code, String message) {
        super(message);
        this.code = code;
    }

    /**
     * Creates a new BusinessException with error code, message, and cause
     * 
     * @param code Error code from ErrorCode constants
     * @param message Human-readable error message
     * @param cause The underlying cause of this exception
     */
    public BusinessException(int code, String message, Throwable cause) {
        super(message, cause);
        this.code = code;
    }
}
