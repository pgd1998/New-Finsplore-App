package com.finsplore.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.EqualsAndHashCode;
import org.hibernate.annotations.CreationTimestamp;

import java.time.ZonedDateTime;

/**
 * Entity for storing blacklisted JWT tokens.
 * 
 * When users logout, their tokens are added to this blacklist
 * to prevent reuse of expired or compromised tokens.
 * 
 * @author Finsplore Team
 */
@Entity
@Table(name = "jwt_blacklist", indexes = {
    @Index(name = "idx_jwt_token", columnList = "token"),
    @Index(name = "idx_jwt_expires_at", columnList = "expires_at")
})
@Getter
@Setter
@ToString
@EqualsAndHashCode(of = "id")
public class JwtBlacklist {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "token", nullable = false, length = 1000)
    private String token;

    @Column(name = "expires_at", nullable = false)
    private ZonedDateTime expiresAt;

    @CreationTimestamp
    @Column(name = "blacklisted_at", nullable = false, updatable = false)
    private ZonedDateTime blacklistedAt;

    // Constructors

    public JwtBlacklist() {
    }

    public JwtBlacklist(String token, ZonedDateTime expiresAt) {
        this.token = token;
        this.expiresAt = expiresAt;
    }

    // Business Methods

    /**
     * Checks if this blacklist entry has expired
     */
    public boolean isExpired() {
        return ZonedDateTime.now().isAfter(expiresAt);
    }
}
