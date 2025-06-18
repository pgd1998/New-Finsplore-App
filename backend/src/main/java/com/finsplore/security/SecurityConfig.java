package com.finsplore.security;

import com.finsplore.security.jwt.JwtAuthenticationFilter;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.Arrays;
import java.util.List;

/**
 * Spring Security configuration for the Finsplore application.
 * 
 * Configures JWT-based authentication, CORS, and API security policies.
 * 
 * @author Finsplore Team
 */
@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtAuthenticationFilter;
    private final SecurityExceptionWriter securityExceptionWriter;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            // Disable CSRF for API
            .csrf(AbstractHttpConfigurer::disable)
            
            // Configure CORS
            .cors(cors -> cors.configurationSource(corsConfigurationSource()))
            
            // Configure session management (stateless)
            .sessionManagement(session -> 
                session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            
            // Configure authorization rules
            .authorizeHttpRequests(auth -> auth
                // Public endpoints
                .requestMatchers(
                    "/api/auth/register",
                    "/api/auth/login",
                    "/api/auth/verify-email",
                    "/api/auth/reset-password",
                    "/actuator/health",
                    "/actuator/info",
                    "/swagger-ui/**",
                    "/v3/api-docs/**"
                ).permitAll()
                
                // All other endpoints require authentication
                .anyRequest().authenticated()
            )
            
            // Configure exception handling
            .exceptionHandling(exceptions -> exceptions
                .authenticationEntryPoint(securityExceptionWriter)
                .accessDeniedHandler(securityExceptionWriter)
            )
            
            // Add JWT filter
            .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        
        // Allow specific origins (configure based on your frontend URLs)
        configuration.setAllowedOriginPatterns(Arrays.asList(
            "http://localhost:*",
            "http://127.0.0.1:*",
            "https://localhost:*",
            "https://127.0.0.1:*"
            // Add your production frontend URLs here
        ));
        
        // Allow specific HTTP methods
        configuration.setAllowedMethods(Arrays.asList(
            "GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"
        ));
        
        // Allow specific headers
        configuration.setAllowedHeaders(Arrays.asList(
            "Authorization",
            "Content-Type",
            "X-Requested-With",
            "Accept",
            "Origin",
            "Access-Control-Request-Method",
            "Access-Control-Request-Headers"
        ));
        
        // Allow credentials
        configuration.setAllowCredentials(true);
        
        // Cache preflight requests
        configuration.setMaxAge(3600L);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        
        return source;
    }
}
