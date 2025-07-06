package com.finsplore.controller;

import com.finsplore.common.ApiResponse;
import com.finsplore.common.ErrorCode;
import com.finsplore.entity.User;
import com.finsplore.repository.UserRepository;
import com.finsplore.service.BasiqService;
import com.finsplore.service.UserService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.HashMap;

/**
 * REST Controller for handling Basiq bank connection operations.
 * 
 * @author Finsplore Team
 */
@RestController
@RequestMapping("/api/basiq")
@CrossOrigin(origins = "*")
public class BasiqController {

    private final BasiqService basiqService;
    private final UserService userService;
    private final UserRepository userRepository;

    @Autowired
    public BasiqController(BasiqService basiqService, UserService userService, UserRepository userRepository) {
        this.basiqService = basiqService;
        this.userService = userService;
        this.userRepository = userRepository;
    }

    /**
     * Creates a Basiq user for the authenticated user
     */
    @PostMapping("/create-user")
    public ResponseEntity<ApiResponse<Map<String, Object>>> createBasiqUser(Authentication authentication) {
        try {
            String userEmail = authentication.getName();
            User user = userService.findByEmail(userEmail)
                    .orElseThrow(() -> new RuntimeException("User not found"));

            // Check if user already has a Basiq ID
            if (user.getBasiqUserId() != null && !user.getBasiqUserId().isEmpty()) {
                Map<String, Object> response = new HashMap<>();
                response.put("basiqUserId", user.getBasiqUserId());
                response.put("message", "Basiq user already exists");

                return ResponseEntity.ok(ApiResponse.success(response, "Basiq user already exists"));
            }

            // Create new Basiq user
            String basiqUserId = basiqService.createBasiqUser(user);

            // Save Basiq user ID to our user record
            user.setBasiqUserId(basiqUserId);
            userRepository.save(user);

            Map<String, Object> response = new HashMap<>();
            response.put("basiqUserId", basiqUserId);
            response.put("message", "Basiq user created successfully");

            return ResponseEntity.ok(ApiResponse.success(response, "Basiq user created successfully"));

        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error(ErrorCode.BASIQ_API_ERROR,
                            "Failed to create Basiq user: " + e.getMessage()));
        }
    }

    /**
     * Generates authentication link for bank connection
     */
    @PostMapping("/auth-link")
    public ResponseEntity<ApiResponse<Map<String, Object>>> generateAuthLink(Authentication authentication) {
        try {
            String userEmail = authentication.getName();
            User user = userService.findByEmail(userEmail)
                    .orElseThrow(() -> new RuntimeException("User not found"));

            // Ensure user has a Basiq user ID
            if (user.getBasiqUserId() == null || user.getBasiqUserId().isEmpty()) {
                String basiqUserId = basiqService.createBasiqUser(user);
                user.setBasiqUserId(basiqUserId);
                userRepository.save(user);
            } else {
                // Update existing Basiq user with user's actual mobile number
                String userMobile = user.getMobileNumber();
                if (userMobile != null && !userMobile.trim().isEmpty()) {
                    System.out.println("📱 Updating Basiq user with mobile: " + userMobile);
                    basiqService.updateBasiqUserMobile(user.getBasiqUserId(), userMobile);
                } else {
                    // Mobile number is required - return error
                    return ResponseEntity.badRequest()
                            .body(ApiResponse.error(400, "Mobile number is required. Please update your profile with a valid mobile number."));
                }
            }

            // Generate auth link - will use user's actual mobile number or allow entry on Basiq's page
            String authLink = basiqService.generateAuthLink(user.getBasiqUserId());

            Map<String, Object> response = new HashMap<>();
            response.put("authLink", authLink);
            response.put("basiqUserId", user.getBasiqUserId());

            return ResponseEntity.ok(ApiResponse.success(response, "Auth link generated successfully"));

        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error(500, "Failed to generate auth link: " + e.getMessage()));
        }
    }

    /**
     * Gets connected bank accounts for the user
     */
    @GetMapping("/accounts")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getConnectedAccounts(Authentication authentication) {
        try {
            String userEmail = authentication.getName();
            User user = userService.findByEmail(userEmail)
                    .orElseThrow(() -> new RuntimeException("User not found"));

            if (user.getBasiqUserId() == null || user.getBasiqUserId().isEmpty()) {
                Map<String, Object> response = new HashMap<>();
                response.put("accounts", new Object[0]);
                response.put("message", "No Basiq user found");

                return ResponseEntity.ok(ApiResponse.success(response, "No connected accounts"));
            }

            // Fetch account balances (which includes account information)
            String accountsJson = basiqService.fetchAccountBalance(user.getBasiqUserId());

            Map<String, Object> response = new HashMap<>();
            response.put("accountsJson", accountsJson);
            response.put("basiqUserId", user.getBasiqUserId());

            return ResponseEntity.ok(ApiResponse.success(response, "Accounts retrieved successfully"));

        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error(500, "Failed to fetch accounts: " + e.getMessage()));
        }
    }

    /**
     * Fetches transactions from connected bank accounts
     */
    @GetMapping("/transactions")
    public ResponseEntity<ApiResponse<Map<String, Object>>> fetchTransactions(Authentication authentication) {
        try {
            String userEmail = authentication.getName();
            User user = userService.findByEmail(userEmail)
                    .orElseThrow(() -> new RuntimeException("User not found"));

            if (user.getBasiqUserId() == null || user.getBasiqUserId().isEmpty()) {
                return ResponseEntity.badRequest()
                        .body(ApiResponse.error(ErrorCode.BASIQ_USER_NOT_FOUND,
                                "No Basiq user found. Please connect a bank account first."));
            }

            // Fetch transactions
            String transactionsJson = basiqService.fetchAllTransactions(user.getBasiqUserId());

            Map<String, Object> response = new HashMap<>();
            response.put("transactionsJson", transactionsJson);
            response.put("basiqUserId", user.getBasiqUserId());

            return ResponseEntity.ok(ApiResponse.success(response, "Transactions retrieved successfully"));

        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error(500, "Failed to fetch transactions: " + e.getMessage()));
        }
    }

    /**
     * Gets account balances from connected banks
     */
    @GetMapping("/balances")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getAccountBalances(Authentication authentication) {
        try {
            String userEmail = authentication.getName();
            User user = userService.findByEmail(userEmail)
                    .orElseThrow(() -> new RuntimeException("User not found"));

            if (user.getBasiqUserId() == null || user.getBasiqUserId().isEmpty()) {
                return ResponseEntity.badRequest()
                        .body(ApiResponse.error(ErrorCode.BASIQ_USER_NOT_FOUND,
                                "No Basiq user found. Please connect a bank account first."));
            }

            // Fetch account balances
            String balancesJson = basiqService.fetchAccountBalance(user.getBasiqUserId());

            Map<String, Object> response = new HashMap<>();
            response.put("balancesJson", balancesJson);
            response.put("basiqUserId", user.getBasiqUserId());

            return ResponseEntity.ok(ApiResponse.success(response, "Balances retrieved successfully"));

        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error(ErrorCode.BASIQ_API_ERROR, "Failed to fetch balances: " + e.getMessage()));
        }
    }

    /**
     * Refreshes data from connected bank accounts
     */
    @PostMapping("/refresh")
    public ResponseEntity<ApiResponse<Map<String, Object>>> refreshBankData(Authentication authentication) {
        try {
            String userEmail = authentication.getName();
            User user = userService.findByEmail(userEmail)
                    .orElseThrow(() -> new RuntimeException("User not found"));

            if (user.getBasiqUserId() == null || user.getBasiqUserId().isEmpty()) {
                return ResponseEntity.badRequest()
                        .body(ApiResponse.error(ErrorCode.BASIQ_USER_NOT_FOUND,
                                "No Basiq user found. Please connect a bank account first."));
            }

            // Refresh both transactions and balances
            String transactionsJson = basiqService.fetchAllTransactions(user.getBasiqUserId());
            String balancesJson = basiqService.fetchAccountBalance(user.getBasiqUserId());

            Map<String, Object> response = new HashMap<>();
            response.put("transactionsJson", transactionsJson);
            response.put("balancesJson", balancesJson);
            response.put("basiqUserId", user.getBasiqUserId());
            response.put("refreshedAt", System.currentTimeMillis());

            return ResponseEntity.ok(ApiResponse.success(response, "Bank data refreshed successfully"));

        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error(ErrorCode.BASIQ_API_ERROR,
                            "Failed to refresh bank data: " + e.getMessage()));
        }
    }
}