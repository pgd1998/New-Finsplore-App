package com.finsplore.repository;

import com.finsplore.entity.JwtBlacklist;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.ZonedDateTime;
import java.util.Optional;

/**
 * Repository interface for JwtBlacklist entity operations.
 * 
 * @author Finsplore Team
 */
@Repository
public interface JwtBlacklistRepository extends JpaRepository<JwtBlacklist, Long> {

    /**
     * Finds a blacklisted token by token value
     */
    Optional<JwtBlacklist> findByToken(String token);

    /**
     * Checks if a token exists in the blacklist
     */
    boolean existsByToken(String token);

    /**
     * Deletes all expired blacklist entries
     */
    @Modifying
    @Query("DELETE FROM JwtBlacklist j WHERE j.expiresAt < :now")
    int deleteExpiredTokens(@Param("now") ZonedDateTime now);

    /**
     * Counts total blacklisted tokens
     */
    @Query("SELECT COUNT(j) FROM JwtBlacklist j")
    long countBlacklistedTokens();

    /**
     * Counts expired blacklisted tokens
     */
    @Query("SELECT COUNT(j) FROM JwtBlacklist j WHERE j.expiresAt < :now")
    long countExpiredTokens(@Param("now") ZonedDateTime now);
}
