package com.finsplore.security.jwt;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtParser;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.Date;
import java.util.function.Function;

/**
 * Utility class for JWT token generation, parsing, and validation.
 * Handles JWT tokens for user authentication in the Finsplore application.
 * 
 * @author Finsplore Team
 */
@Component
public class JwtUtil {

    // Default fallback values - should be overridden by application.properties
    private static final String DEFAULT_SECRET_KEY = "finsplore-default-very-secure-256-bit-secret-key-for-jwt-tokens-change-in-production";
    private static final long DEFAULT_EXPIRATION_HOURS = 24 * 7; // 7 days

    @Value("${finsplore.jwt.secret:#{null}}")
    private String configuredSecretKey;

    @Value("${finsplore.jwt.expiration-hours:168}") // 168 hours = 7 days
    private long expirationHours;

    private SecretKey secretKey;
    private JwtParser jwtParser;

    /**
     * Initialize JWT components with secret key
     */
    private void initializeJwtComponents() {
        if (secretKey == null) {
            String keyToUse = (configuredSecretKey != null && !configuredSecretKey.isEmpty()) 
                ? configuredSecretKey 
                : DEFAULT_SECRET_KEY;
            
            secretKey = Keys.hmacShaKeyFor(keyToUse.getBytes(StandardCharsets.UTF_8));
            jwtParser = Jwts.parser()
                .verifyWith(secretKey)
                .build();
        }
    }

    /**
     * Generates a JWT token for the given user
     *
     * @param email the user's email (used as subject)
     * @param userId the user's ID
     * @return the JWT token as a String
     */
    public String generateToken(String email, Long userId) {
        initializeJwtComponents();
        
        Instant now = Instant.now();
        Instant expiry = now.plusSeconds(expirationHours * 3600); // Convert hours to seconds
        
        return Jwts.builder()
            .subject(email)
            .claim("userId", userId)
            .claim("email", email)
            .issuedAt(Date.from(now))
            .expiration(Date.from(expiry))
            .signWith(secretKey)
            .compact();
    }

    /**
     * Extracts all claims from the JWT token
     */
    public Claims extractAllClaims(String token) {
        initializeJwtComponents();
        return jwtParser
            .parseSignedClaims(token)
            .getPayload();
    }

    /**
     * Extracts a specific claim from the JWT token
     */
    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        Claims claims = extractAllClaims(token);
        return claimsResolver.apply(claims);
    }

    /**
     * Extracts the email (subject) from the JWT token
     */
    public String extractEmail(String token) {
        return extractClaim(token, Claims::getSubject);
    }

    /**
     * Extracts the user ID from the JWT token
     */
    public Long extractUserId(String token) {
        return extractClaim(token, claims -> claims.get("userId", Long.class));
    }

    /**
     * Extracts the expiration date from the JWT token
     */
    public Date extractExpiration(String token) {
        return extractClaim(token, Claims::getExpiration);
    }

    /**
     * Checks if the JWT token is expired
     */
    public boolean isTokenExpired(String token) {
        try {
            return extractExpiration(token).before(new Date());
        } catch (Exception e) {
            return true; // Consider invalid tokens as expired
        }
    }

    /**
     * Validates the JWT token
     */
    public boolean validateToken(String token) {
        try {
            return !isTokenExpired(token);
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Validates the JWT token for a specific user
     */
    public boolean validateTokenForUser(String token, String email) {
        try {
            String tokenEmail = extractEmail(token);
            return email.equals(tokenEmail) && !isTokenExpired(token);
        } catch (Exception e) {
            return false;
        }
    }
}
