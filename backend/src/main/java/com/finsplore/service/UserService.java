package com.finsplore.service;

import com.finsplore.common.ErrorCode;
import com.finsplore.dto.UserLoginRequest;
import com.finsplore.dto.UserProfileResponse;
import com.finsplore.dto.UserProfileUpdateRequest;
import com.finsplore.dto.UserRegistrationRequest;
import com.finsplore.entity.User;
import com.finsplore.exception.BusinessException;
import com.finsplore.repository.UserRepository;
import com.finsplore.util.PasswordEncoderUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.ZonedDateTime;
import java.util.Optional;

/**
 * Service layer for User management operations.
 * 
 * Handles user registration, authentication, profile management,
 * and integrates with external services like Basiq.
 * 
 * @author Finsplore Team
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final EmailService emailService;
    private final BasiqService basiqService;

    /**
     * Registers a new user in the system
     */
    @Transactional
    public User registerUser(UserRegistrationRequest request) {
        log.info("Registering new user with email: {}", request.getEmail());

        // Check if user already exists
        if (userRepository.findByEmail(request.getEmail()).isPresent()) {
            throw new BusinessException(ErrorCode.USER_EXISTS, "User with this email already exists");
        }

        // Check if username is taken (if provided)
        if (request.getUsername() != null && 
            userRepository.findByUsername(request.getUsername()).isPresent()) {
            throw new BusinessException(ErrorCode.USER_EXISTS, "Username is already taken");
        }

        // Create new user
        User user = new User();
        user.setEmail(request.getEmail());
        user.setPasswordHash(PasswordEncoderUtil.encode(request.getPassword()));
        user.setFirstName(request.getFirstName());
        user.setMiddleName(request.getMiddleName());
        user.setLastName(request.getLastName());
        user.setMobileNumber(request.getMobileNumber());
        user.setUsername(request.getUsername());

        User savedUser = userRepository.save(user);

        // Create Basiq user asynchronously
        try {
            String basiqUserId = basiqService.createBasiqUser(savedUser);
            savedUser.setBasiqUserId(basiqUserId);
            savedUser = userRepository.save(savedUser);
            log.info("Created Basiq user for: {} with ID: {}", savedUser.getEmail(), basiqUserId);
        } catch (Exception e) {
            log.error("Failed to create Basiq user for: {}", savedUser.getEmail(), e);
            // Don't fail registration if Basiq creation fails
        }

        // Send welcome email asynchronously
        try {
            emailService.sendWelcomeEmail(savedUser.getEmail(), savedUser.getFirstName());
            log.info("Welcome email sent to: {}", savedUser.getEmail());
        } catch (Exception e) {
            log.error("Failed to send welcome email to: {}", savedUser.getEmail(), e);
            // Don't fail registration if email fails
        }

        log.info("Successfully registered user: {}", savedUser.getEmail());
        return savedUser;
    }

    /**
     * Authenticates a user and returns user details
     */
    public User loginUser(UserLoginRequest request) {
        log.info("Login attempt for email: {}", request.getEmail());

        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new BusinessException(ErrorCode.USER_NOT_FOUND, "Invalid email or password"));

        if (!user.getIsActive()) {
            throw new BusinessException(ErrorCode.USER_INACTIVE, "Account is deactivated");
        }

        if (!PasswordEncoderUtil.matches(request.getPassword(), user.getPasswordHash())) {
            throw new BusinessException(ErrorCode.AUTH_FAILED, "Invalid email or password");
        }

        // Update last login time
        user.updateLastLogin();
        userRepository.save(user);

        log.info("Successful login for user: {}", user.getEmail());
        return user;
    }

    /**
     * Gets user profile by email
     */
    public UserProfileResponse getUserProfile(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new BusinessException(ErrorCode.USER_NOT_FOUND, "User not found"));

        return convertToProfileResponse(user);
    }

    /**
     * Gets user profile by ID
     */
    public UserProfileResponse getUserProfile(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.USER_NOT_FOUND, "User not found"));

        return convertToProfileResponse(user);
    }

    /**
     * Updates user profile
     */
    @Transactional
    public UserProfileResponse updateUserProfile(String email, UserProfileUpdateRequest request) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new BusinessException(ErrorCode.USER_NOT_FOUND, "User not found"));

        // Update fields if provided
        if (request.getFirstName() != null) {
            user.setFirstName(request.getFirstName());
        }
        if (request.getMiddleName() != null) {
            user.setMiddleName(request.getMiddleName());
        }
        if (request.getLastName() != null) {
            user.setLastName(request.getLastName());
        }
        if (request.getMobileNumber() != null) {
            user.setMobileNumber(request.getMobileNumber());
        }
        if (request.getUsername() != null) {
            // Check if username is taken by another user
            Optional<User> existingUser = userRepository.findByUsername(request.getUsername());
            if (existingUser.isPresent() && !existingUser.get().getId().equals(user.getId())) {
                throw new BusinessException(ErrorCode.USER_EXISTS, "Username is already taken");
            }
            user.setUsername(request.getUsername());
        }
        if (request.getAvatarUrl() != null) {
            user.setAvatarUrl(request.getAvatarUrl());
        }
        if (request.getMonthlyBudget() != null) {
            user.setMonthlyBudget(request.getMonthlyBudget());
        }
        if (request.getSavingsGoal() != null) {
            user.setSavingsGoal(request.getSavingsGoal());
        }

        User updatedUser = userRepository.save(user);
        log.info("Updated profile for user: {}", user.getEmail());

        return convertToProfileResponse(updatedUser);
    }

    /**
     * Verifies user email
     */
    @Transactional
    public void verifyEmail(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new BusinessException(ErrorCode.USER_NOT_FOUND, "User not found"));

        user.verifyEmail();
        userRepository.save(user);

        log.info("Email verified for user: {}", email);
    }

    /**
     * Resets user password
     */
    @Transactional
    public void resetPassword(String email, String newPassword) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new BusinessException(ErrorCode.USER_NOT_FOUND, "User not found"));

        user.setPasswordHash(PasswordEncoderUtil.encode(newPassword));
        userRepository.save(user);

        log.info("Password reset for user: {}", email);
    }

    /**
     * Deactivates a user account
     */
    @Transactional
    public void deactivateUser(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new BusinessException(ErrorCode.USER_NOT_FOUND, "User not found"));

        user.setIsActive(false);
        userRepository.save(user);

        log.info("Deactivated user: {}", email);
    }

    /**
     * Finds user by email
     */
    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    /**
     * Finds user by ID
     */
    public Optional<User> findById(Long id) {
        return userRepository.findById(id);
    }

    /**
     * Generates authentication link for banking integration
     */
    public String generateAuthLink(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.USER_NOT_FOUND, "User not found"));

        if (user.getBasiqUserId() == null) {
            throw new BusinessException(ErrorCode.BASIQ_USER_NOT_FOUND, "Basiq user not created for this user");
        }

        return basiqService.generateAuthLink(user.getBasiqUserId());
    }

    /**
     * Updates Basiq user ID
     */
    @Transactional
    public void updateBasiqUserId(Long userId, String basiqUserId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.USER_NOT_FOUND, "User not found"));

        user.setBasiqUserId(basiqUserId);
        userRepository.save(user);

        log.info("Updated Basiq user ID for user: {}", user.getEmail());
    }

    /**
     * Converts User entity to UserProfileResponse DTO
     */
    private UserProfileResponse convertToProfileResponse(User user) {
        UserProfileResponse response = new UserProfileResponse();
        response.setId(user.getId());
        response.setEmail(user.getEmail());
        response.setFirstName(user.getFirstName());
        response.setMiddleName(user.getMiddleName());
        response.setLastName(user.getLastName());
        response.setMobileNumber(user.getMobileNumber());
        response.setUsername(user.getUsername());
        response.setBasiqUserId(user.getBasiqUserId());
        response.setAvatarUrl(user.getAvatarUrl());
        response.setMonthlyBudget(user.getMonthlyBudget());
        response.setSavingsGoal(user.getSavingsGoal());
        response.setIsEmailVerified(user.getIsEmailVerified());
        response.setIsActive(user.getIsActive());
        response.setEmailVerifiedAt(user.getEmailVerifiedAt());
        response.setCreatedAt(user.getCreatedAt());
        response.setUpdatedAt(user.getUpdatedAt());
        response.setLastLoginAt(user.getLastLoginAt());

        return response;
    }
}
