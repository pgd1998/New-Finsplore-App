package com.finsplore.exception;

import com.finsplore.common.ApiResponse;
import com.finsplore.common.ErrorCode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.HttpRequestMethodNotSupportedException;

import jakarta.validation.ConstraintViolationException;

/**
 * Global exception handler for the Finsplore application.
 * Provides consistent error responses across all REST endpoints.
 * 
 * @author Finsplore Team
 */
@RestControllerAdvice
public class GlobalExceptionHandler {
    
    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    /**
     * Handles generic uncaught exceptions
     */
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiResponse<String>> handleGenericException(Exception e) {
        logger.error("Unexpected error occurred", e);
        return ResponseEntity
            .status(HttpStatus.INTERNAL_SERVER_ERROR)
            .body(ApiResponse.error(ErrorCode.SYSTEM_ERROR, "Internal Server Error"));
    }

    /**
     * Handles validation errors from @Valid annotations
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiResponse<String>> handleValidationException(MethodArgumentNotValidException e) {
        FieldError fieldError = e.getBindingResult().getFieldError();
        String errorMessage = (fieldError != null) ? fieldError.getDefaultMessage() : "Validation error";
        logger.warn("Validation error: {}", errorMessage);
        return ResponseEntity
            .status(HttpStatus.BAD_REQUEST)
            .body(ApiResponse.error(ErrorCode.PARAM_INVALID, errorMessage));
    }

    /**
     * Handles constraint violation exceptions
     */
    @ExceptionHandler(ConstraintViolationException.class)
    public ResponseEntity<ApiResponse<String>> handleConstraintViolationException(ConstraintViolationException e) {
        logger.warn("Constraint violation: {}", e.getMessage());
        return ResponseEntity
            .status(HttpStatus.BAD_REQUEST)
            .body(ApiResponse.error(ErrorCode.PARAM_INVALID, "Invalid input parameters"));
    }

    /**
     * Handles type mismatch errors (e.g., string passed where integer expected)
     */
    @ExceptionHandler(MethodArgumentTypeMismatchException.class)
    public ResponseEntity<ApiResponse<String>> handleTypeMismatchException(MethodArgumentTypeMismatchException e) {
        logger.warn("Type mismatch error: {}", e.getMessage());
        return ResponseEntity
            .status(HttpStatus.BAD_REQUEST)
            .body(ApiResponse.error(ErrorCode.PARAM_TYPE_MISMATCH, "Invalid parameter type"));
    }

    /**
     * Handles HTTP method not supported errors
     */
    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    public ResponseEntity<ApiResponse<String>> handleMethodNotSupportedException(HttpRequestMethodNotSupportedException e) {
        logger.warn("Method not supported: {}", e.getMessage());
        return ResponseEntity
            .status(HttpStatus.METHOD_NOT_ALLOWED)
            .body(ApiResponse.error(ErrorCode.REQUEST_METHOD_NOT_SUPPORTED, "HTTP method not supported"));
    }

    /**
     * Handles business logic exceptions
     */
    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<ApiResponse<String>> handleBusinessException(BusinessException e) {
        logger.warn("Business exception: {} (code: {})", e.getMessage(), e.getCode());
        
        // Map business error codes to appropriate HTTP status codes
        HttpStatus status = mapBusinessErrorToHttpStatus(e.getCode());
        
        return ResponseEntity
            .status(status)
            .body(ApiResponse.error(e.getCode(), e.getMessage()));
    }

    /**
     * Maps business error codes to appropriate HTTP status codes
     */
    private HttpStatus mapBusinessErrorToHttpStatus(int errorCode) {
        if (errorCode >= 2000 && errorCode < 3000) {
            // Authentication/Authorization errors
            if (errorCode == ErrorCode.UNAUTHORIZED || errorCode == ErrorCode.TOKEN_EXPIRED) {
                return HttpStatus.UNAUTHORIZED;
            }
            if (errorCode == ErrorCode.FORBIDDEN) {
                return HttpStatus.FORBIDDEN;
            }
            return HttpStatus.UNAUTHORIZED;
        } else if (errorCode >= 3000 && errorCode < 4000) {
            // Resource errors
            if (errorCode == ErrorCode.RESOURCE_NOT_FOUND) {
                return HttpStatus.NOT_FOUND;
            }
            if (errorCode == ErrorCode.RESOURCE_ALREADY_EXISTS) {
                return HttpStatus.CONFLICT;
            }
            return HttpStatus.BAD_REQUEST;
        } else if (errorCode >= 4000 && errorCode < 5000) {
            // Business logic errors
            return HttpStatus.CONFLICT;
        } else if (errorCode >= 5000) {
            // System errors
            return HttpStatus.INTERNAL_SERVER_ERROR;
        } else {
            // Parameter errors (1xxx)
            return HttpStatus.BAD_REQUEST;
        }
    }
}
