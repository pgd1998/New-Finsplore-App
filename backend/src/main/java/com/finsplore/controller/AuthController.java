package com.finsplore.controller;

import com.finsplore.common.ApiResponse;
import com.finsplore.common.ErrorCode;
import com.finsplore.dto.UserLoginRequest;
import com.finsplore.dto.UserProfileResponse;
import com.finsplore.dto.UserProfileUpdateRequest;
import com.finsplore.dto.UserRegistrationRequest;
import com.finsplore.entity.User;
import com.finsplore.security.jwt.JwtUtil;
import com.finsplore.service.JwtBlacklistService;
import com.finsplore.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * Authentication controller handling user registration, login, logout, and profile operations.
 * 
 * Combines the best practices from both RedBack and BlueRing implementations:
 * - RedBack's clean API response structure and JWT management
 * - BlueRing's comprehensive user operations and external service integration
 * 
 * @author Finsplore Team
 */
@Slf4j
@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final UserService userService;
    private final JwtUtil jwtUtil;
    private final JwtBlacklistService jwtBlacklistService;

    /**
     * Register a new user
     */
    @PostMapping("/register")
    public ResponseEntity<ApiResponse<Map<String, Object>>> register(@Valid @RequestBody UserRegistrationRequest request) {
        log.info("Registration request received for email: {}", request.getEmail());

        User user = userService.registerUser(request);
        
        Map<String, Object> responseData = new HashMap<>();
        responseData.put("userId", user.getId());
        responseData.put("email", user.getEmail());
        responseData.put("fullName", user.getFullName());
        responseData.put("basiqUserId", user.getBasiqUserId());

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(ApiResponse.success(responseData, "User registered successfully!"));
    }

    /**
     * Authenticate user and return JWT token
     */
    @PostMapping("/login")
    public ResponseEntity<ApiResponse<Map<String, Object>>> login(@Valid @RequestBody UserLoginRequest request) {
        log.info("Login request received for email: {}", request.getEmail());

        User user = userService.loginUser(request);
        String token = jwtUtil.generateToken(user.getEmail(), user.getId());
        
        Map<String, Object> responseData = new HashMap<>();
        responseData.put("userId", user.getId());
        responseData.put("email", user.getEmail());
        responseData.put("fullName", user.getFullName());
        responseData.put("displayName", user.getDisplayName());
        responseData.put("basiqUserId", user.getBasiqUserId());
        responseData.put("token", token);
        responseData.put("isEmailVerified", user.getIsEmailVerified());
        responseData.put("isProfileComplete", user.isProfileComplete());

        return ResponseEntity
                .ok(ApiResponse.success(responseData, "Login successful!"));
    }

    /**
     * Get current user profile
     */
    @GetMapping("/profile")
    public ResponseEntity<ApiResponse<UserProfileResponse>> getProfile() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity
                    .status(HttpStatus.UNAUTHORIZED)
                    .body(ApiResponse.error(ErrorCode.FORBIDDEN, "You are not authenticated!"));
        }

        String email = (String) authentication.getPrincipal();
        UserProfileResponse profile = userService.getUserProfile(email);
        
        return ResponseEntity
                .ok(ApiResponse.success(profile, "Profile retrieved successfully"));
    }

    /**
     * Update current user profile
     */
    @PutMapping("/profile")
    public ResponseEntity<ApiResponse<UserProfileResponse>> updateProfile(
            @Valid @RequestBody UserProfileUpdateRequest request) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity
                    .status(HttpStatus.UNAUTHORIZED)
                    .body(ApiResponse.error(ErrorCode.FORBIDDEN, "You are not authenticated!"));
        }

        String email = (String) authentication.getPrincipal();
        UserProfileResponse updatedProfile = userService.updateUserProfile(email, request);
        
        return ResponseEntity
                .ok(ApiResponse.success(updatedProfile, "Profile updated successfully"));
    }

    /**
     * Verify user email
     */
    @PostMapping("/verify-email")
    public ResponseEntity<ApiResponse<String>> verifyEmail(@RequestParam String email) {
        userService.verifyEmail(email);
        
        return ResponseEntity
                .ok(ApiResponse.success("Email verified successfully"));
    }

    /**
     * Request password reset
     */
    @PostMapping("/reset-password")
    public ResponseEntity<ApiResponse<String>> resetPassword(
            @RequestParam String email,
            @RequestParam String newPassword) {
        userService.resetPassword(email, newPassword);
        
        return ResponseEntity
                .ok(ApiResponse.success("Password reset successfully"));
    }

    /**
     * Generate authentication link for bank account connection
     */
    @PostMapping("/generate-auth-link")
    public ResponseEntity<ApiResponse<Map<String, String>>> generateAuthLink() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity
                    .status(HttpStatus.UNAUTHORIZED)
                    .body(ApiResponse.error(ErrorCode.FORBIDDEN, "You are not authenticated!"));
        }

        // Extract user ID from JWT claims
        String email = (String) authentication.getPrincipal();
        UserProfileResponse profile = userService.getUserProfile(email);
        
        String authLink = userService.generateAuthLink(profile.getId());
        
        Map<String, String> responseData = new HashMap<>();
        responseData.put("authLink", authLink);
        
        return ResponseEntity
                .ok(ApiResponse.success(responseData, "Authentication link generated successfully"));
    }

    /**
     * Logs the user out by blacklisting the JWT token from the Authorization header.
     * Once blacklisted, the token cannot be used for authentication again.
     *
     * @param request the HTTP request containing the Authorization header
     * @return ApiResponse with a success message or error if the token is missing or malformed
     */
    @PostMapping("/logout")
    public ResponseEntity<ApiResponse<String>> logout(HttpServletRequest request) {
        String authHeader = request.getHeader("Authorization");

        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(ApiResponse.error(ErrorCode.PARAM_INVALID, "Authorization header is missing or malformed"));
        }

        String token = authHeader.replace("Bearer ", "").trim();
        jwtBlacklistService.blacklistToken(token);

        return ResponseEntity.ok(ApiResponse.success("Logout successful. Token has been invalidated."));
    }
}
