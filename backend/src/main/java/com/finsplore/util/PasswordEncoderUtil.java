package com.finsplore.util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

/**
 * Utility class for password encoding and validation.
 * Uses BCrypt for secure password hashing.
 * 
 * @author Finsplore Team
 */
public class PasswordEncoderUtil {
    
    // Thread-safe BCrypt encoder with default strength (10)
    private static final PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    /**
     * Encodes a raw password using BCrypt
     * 
     * @param rawPassword the plain text password
     * @return the BCrypt encoded password
     */
    public static String encode(String rawPassword) {
        if (rawPassword == null || rawPassword.isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty");
        }
        return passwordEncoder.encode(rawPassword);
    }

    /**
     * Checks if a raw password matches an encoded password
     * 
     * @param rawPassword the plain text password
     * @param encodedPassword the BCrypt encoded password
     * @return true if passwords match, false otherwise
     */
    public static boolean matches(String rawPassword, String encodedPassword) {
        if (rawPassword == null || encodedPassword == null) {
            return false;
        }
        return passwordEncoder.matches(rawPassword, encodedPassword);
    }

    /**
     * Gets the underlying PasswordEncoder instance
     * Useful for Spring Security configuration
     * 
     * @return the PasswordEncoder instance
     */
    public static PasswordEncoder getEncoder() {
        return passwordEncoder;
    }
}
