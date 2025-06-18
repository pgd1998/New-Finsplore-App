package com.finsplore.service;

import com.finsplore.entity.JwtBlacklist;
import com.finsplore.repository.JwtBlacklistRepository;
import com.finsplore.security.jwt.JwtUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.ZonedDateTime;

/**
 * Service for managing JWT token blacklist operations.
 * 
 * Handles blacklisting tokens on logout and cleanup of expired entries.
 * 
 * @author Finsplore Team
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class JwtBlacklistService {

    private final JwtBlacklistRepository jwtBlacklistRepository;
    private final JwtUtil jwtUtil;

    /**
     * Blacklists a JWT token to prevent its reuse
     */
    @Transactional
    public void blacklistToken(String token) {
        try {
            // Check if token is already blacklisted
            if (jwtBlacklistRepository.existsByToken(token)) {
                log.debug("Token is already blacklisted");
                return;
            }

            // Extract expiration time from token
            ZonedDateTime expiresAt = jwtUtil.extractExpirationAsZonedDateTime(token);
            
            // Create blacklist entry
            JwtBlacklist blacklistEntry = new JwtBlacklist(token, expiresAt);
            jwtBlacklistRepository.save(blacklistEntry);
            
            log.info("Successfully blacklisted JWT token");
            
        } catch (Exception e) {
            log.error("Failed to blacklist token", e);
            throw new RuntimeException("Failed to blacklist token", e);
        }
    }

    /**
     * Checks if a token is blacklisted
     */
    public boolean isTokenBlacklisted(String token) {
        try {
            return jwtBlacklistRepository.existsByToken(token);
        } catch (Exception e) {
            log.error("Error checking token blacklist status", e);
            // Fail secure - treat as blacklisted if we can't check
            return true;
        }
    }

    /**
     * Cleanup expired blacklist entries
     * Runs every hour to maintain database performance
     */
    @Scheduled(fixedRate = 3600000) // 1 hour = 3600000 ms
    @Transactional
    public void cleanupExpiredTokens() {
        try {
            ZonedDateTime now = ZonedDateTime.now();
            
            // Count expired tokens before cleanup
            long expiredCount = jwtBlacklistRepository.countExpiredTokens(now);
            
            if (expiredCount > 0) {
                // Delete expired tokens
                int deletedCount = jwtBlacklistRepository.deleteExpiredTokens(now);
                log.info("Cleaned up {} expired blacklisted tokens", deletedCount);
            } else {
                log.debug("No expired tokens to cleanup");
            }
            
        } catch (Exception e) {
            log.error("Failed to cleanup expired blacklisted tokens", e);
        }
    }

    /**
     * Gets blacklist statistics
     */
    public BlacklistStats getBlacklistStats() {
        try {
            ZonedDateTime now = ZonedDateTime.now();
            long totalTokens = jwtBlacklistRepository.countBlacklistedTokens();
            long expiredTokens = jwtBlacklistRepository.countExpiredTokens(now);
            long activeTokens = totalTokens - expiredTokens;
            
            return new BlacklistStats(totalTokens, activeTokens, expiredTokens);
            
        } catch (Exception e) {
            log.error("Failed to get blacklist statistics", e);
            return new BlacklistStats(0, 0, 0);
        }
    }

    /**
     * Manually trigger cleanup (for admin operations)
     */
    @Transactional
    public int manualCleanup() {
        try {
            ZonedDateTime now = ZonedDateTime.now();
            int deletedCount = jwtBlacklistRepository.deleteExpiredTokens(now);
            log.info("Manual cleanup removed {} expired tokens", deletedCount);
            return deletedCount;
        } catch (Exception e) {
            log.error("Failed to perform manual cleanup", e);
            throw new RuntimeException("Failed to perform manual cleanup", e);
        }
    }

    /**
     * Statistics holder for blacklist data
     */
    public static class BlacklistStats {
        public final long totalTokens;
        public final long activeTokens;
        public final long expiredTokens;

        public BlacklistStats(long totalTokens, long activeTokens, long expiredTokens) {
            this.totalTokens = totalTokens;
            this.activeTokens = activeTokens;
            this.expiredTokens = expiredTokens;
        }
    }
}
