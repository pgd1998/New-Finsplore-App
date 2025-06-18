package com.finsplore.security.jwt;

import com.finsplore.service.JwtBlacklistService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.ArrayList;

/**
 * JWT Authentication Filter that processes incoming requests and validates JWT tokens.
 * 
 * This filter runs for every request and:
 * 1. Extracts JWT token from Authorization header
 * 2. Validates the token
 * 3. Checks if token is blacklisted
 * 4. Sets up Spring Security authentication context
 * 
 * @author Finsplore Team
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtUtil jwtUtil;
    private final JwtBlacklistService jwtBlacklistService;

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain) throws ServletException, IOException {

        final String authHeader = request.getHeader("Authorization");
        final String jwt;
        final String userEmail;

        // Skip if no Authorization header or doesn't start with "Bearer "
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }

        // Extract JWT token
        jwt = authHeader.substring(7);

        try {
            // Check if token is blacklisted
            if (jwtBlacklistService.isTokenBlacklisted(jwt)) {
                log.debug("Request attempted with blacklisted token");
                filterChain.doFilter(request, response);
                return;
            }

            // Extract user email from token
            userEmail = jwtUtil.extractEmail(jwt);

            // If token is valid and no authentication exists in context
            if (userEmail != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                
                // Validate token
                if (jwtUtil.validateToken(jwt)) {
                    // Create authentication token
                    UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
                            userEmail,
                            null,
                            new ArrayList<>() // No roles for now, can be extended later
                    );
                    
                    // Set authentication details
                    authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                    
                    // Set authentication in security context
                    SecurityContextHolder.getContext().setAuthentication(authToken);
                    
                    log.debug("Successfully authenticated user: {}", userEmail);
                } else {
                    log.debug("Invalid JWT token for user: {}", userEmail);
                }
            }
        } catch (Exception e) {
            log.error("Error processing JWT token: {}", e.getMessage());
            // Don't block the request, just don't set authentication
        }

        filterChain.doFilter(request, response);
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) throws ServletException {
        String path = request.getRequestURI();
        
        // Skip JWT validation for public endpoints
        return path.startsWith("/api/auth/register") ||
               path.startsWith("/api/auth/login") ||
               path.startsWith("/api/auth/verify-email") ||
               path.startsWith("/api/auth/reset-password") ||
               path.startsWith("/actuator/health") ||
               path.startsWith("/actuator/info") ||
               path.startsWith("/swagger-ui/") ||
               path.startsWith("/v3/api-docs/");
    }
}
