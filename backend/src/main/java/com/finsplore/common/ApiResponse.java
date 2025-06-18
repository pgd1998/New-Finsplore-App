package com.finsplore.common;

import lombok.*;

/**
 * Standardized API response wrapper for all REST endpoints.
 * Provides consistent response format across the application.
 * 
 * @param <T> The type of data being returned
 * @author Finsplore Team
 */
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class ApiResponse<T> {
    private int code;
    private String message;
    private T data;

    /**
     * Creates a successful response with data
     */
    public static <T> ApiResponse<T> success(T data) {
        return new ApiResponse<>(ErrorCode.SUCCESS, "Success", data);
    }

    /**
     * Creates a successful response with data and custom message
     */
    public static <T> ApiResponse<T> success(T data, String message) {
        return new ApiResponse<>(ErrorCode.SUCCESS, message, data);
    }

    /**
     * Creates a successful response with just a message (no data)
     */
    public static <T> ApiResponse<T> success(String message) {
        return new ApiResponse<>(ErrorCode.SUCCESS, message, null);
    }

    /**
     * Creates an error response with error code and message
     */
    public static <T> ApiResponse<T> error(int code, String message) {
        return new ApiResponse<>(code, message, null);
    }

    /**
     * Creates an error response with error code, message, and data
     */
    public static <T> ApiResponse<T> error(int code, String message, T data) {
        return new ApiResponse<>(code, message, data);
    }
}
