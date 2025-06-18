package com.finsplore.security;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.finsplore.common.ApiResponse;
import com.finsplore.common.ErrorCode;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;

/**
 * Custom security exception handler for authentication and authorization failures.
 * 
 * Provides consistent JSON error responses for security-related exceptions.
 * 
 * @author Finsplore Team
 */
@Slf4j
@Component
public class SecurityExceptionWriter implements AuthenticationEntryPoint, AccessDeniedHandler {

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public void commence(HttpServletRequest request, HttpServletResponse response,
                        AuthenticationException authException) throws IOException, ServletException {
        
        log.debug("Authentication failed for request: {} - {}", request.getRequestURI(), authException.getMessage());
        
        ApiResponse<String> errorResponse = ApiResponse.error(
            ErrorCode.AUTH_FAILED, 
            "Authentication required. Please provide a valid JWT token."
        );
        
        writeErrorResponse(response, HttpServletResponse.SC_UNAUTHORIZED, errorResponse);
    }

    @Override
    public void handle(HttpServletRequest request, HttpServletResponse response,
                      AccessDeniedException accessDeniedException) throws IOException, ServletException {
        
        log.debug("Access denied for request: {} - {}", request.getRequestURI(), accessDeniedException.getMessage());
        
        ApiResponse<String> errorResponse = ApiResponse.error(
            ErrorCode.FORBIDDEN, 
            "Access denied. You don't have permission to access this resource."
        );
        
        writeErrorResponse(response, HttpServletResponse.SC_FORBIDDEN, errorResponse);
    }

    private void writeErrorResponse(HttpServletResponse response, int status, ApiResponse<String> errorResponse) 
            throws IOException {
        
        response.setStatus(status);
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.setCharacterEncoding("UTF-8");
        
        String responseBody = objectMapper.writeValueAsString(errorResponse);
        response.getWriter().write(responseBody);
    }
}
