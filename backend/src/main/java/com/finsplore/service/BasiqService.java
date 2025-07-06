package com.finsplore.service;

import com.finsplore.dto.BasiqAuthLinkRequest;
import com.finsplore.dto.BasiqAuthLinkResponse;
import com.finsplore.dto.BasiqTokenResponse;
import com.finsplore.dto.BasiqUserRequest;
import com.finsplore.dto.BasiqUserResponse;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import reactor.core.publisher.Mono;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * Service class for interacting with the Basiq API.
 * Handles user creation, authentication, and transaction fetching.
 * 
 * @author Finsplore Team
 */
@Service
public class BasiqService {

    private final WebClient webClient;

    // Inject API key from application properties
    @Value("${basiq.api.key}")
    private String basiqApiKey;

    private String accessToken;
    private long tokenExpireTime = 0;

    public BasiqService(WebClient.Builder webClientBuilder) {
        this.webClient = webClientBuilder.baseUrl("https://au-api.basiq.io").build();
    }

    /**
     * Authenticates with Basiq API and gets access token
     */
    public void authenticate() {
        Mono<BasiqTokenResponse> responseMono = webClient.post()
                .uri("/token")
                .header(HttpHeaders.AUTHORIZATION, "Basic " + basiqApiKey)
                .header(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_FORM_URLENCODED_VALUE)
                .header("basiq-version", "3.0")
                .body(BodyInserters.fromFormData("scope", "SERVER_ACCESS"))
                .retrieve()
                .bodyToMono(BasiqTokenResponse.class);

        BasiqTokenResponse tokenResponse = responseMono.block();

        if (tokenResponse != null) {
            this.accessToken = tokenResponse.getAccessToken();
            this.tokenExpireTime = System.currentTimeMillis() + (60 * 60 * 1000); // 1 hour

            System.out.println("Basiq Access Token: " + this.accessToken);
        } else {
            throw new RuntimeException("Failed to authenticate with Basiq API");
        }
    }

    /**
     * Ensures we have a valid access token
     */
    private void ensureAuthenticated() {
        if (this.accessToken == null || System.currentTimeMillis() > tokenExpireTime) {
            authenticate();
        }
    }

    /**
     * Creates a new Basiq user
     */
    public String createUser(String email, String mobile, String firstName, String lastName) {
        ensureAuthenticated();
        Mono<BasiqUserResponse> responseMono = webClient.post()
                .uri("/users")
                .header(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken)
                .header("basiq-version", "3.0") // ← ADD THIS LINE
                .contentType(MediaType.APPLICATION_JSON)
                .body(BodyInserters.fromValue(new BasiqUserRequest(email, mobile, firstName, lastName)))
                .retrieve()
                .bodyToMono(BasiqUserResponse.class);

        BasiqUserResponse userResponse = responseMono.block();

        if (userResponse != null) {
            return userResponse.getId();
        } else {
            throw new RuntimeException("Failed to create user with Basiq API");
        }
    }

    /**
     * Creates a Basiq user for an existing app user
     */
    public String createBasiqUser(com.finsplore.entity.User user) {
        return createUser(
                user.getEmail(),
                user.getMobileNumber() != null ? user.getMobileNumber() : "",
                user.getFirstName() != null ? user.getFirstName() : "",
                user.getLastName() != null ? user.getLastName() : "");
    }

    /**
     * Generates authentication link for bank account linking
     */
    public String generateAuthLink(String userId) {
        ensureAuthenticated();

        Mono<BasiqAuthLinkResponse> responseMono = webClient.post()
                .uri("/users/" + userId + "/auth_link")
                .header(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken)
                .header("basiq-version", "3.0") // ← ADD THIS LINE
                .contentType(MediaType.APPLICATION_JSON)
                .body(BodyInserters.fromValue(new BasiqAuthLinkRequest()))
                .retrieve()
                .bodyToMono(BasiqAuthLinkResponse.class);

        BasiqAuthLinkResponse authLinkResponse = responseMono.block();

        if (authLinkResponse != null && authLinkResponse.getLinks() != null) {
            String authLink = authLinkResponse.getLinks().getPublic();
            return authLink;
        } else {
            throw new RuntimeException("Failed to generate auth link for Basiq user");
        }
    }

    /**
     * Fetches all transactions for a user
     */
    public String fetchAllTransactions(String userId) {
        ensureAuthenticated();

        Mono<String> responseMono = webClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path("/users/" + userId + "/transactions")
                        .queryParam("limit", 500)
                        .build())
                .header(HttpHeaders.ACCEPT, MediaType.APPLICATION_JSON_VALUE)
                .header(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken)
                .header("basiq-version", "3.0") // ← ADD THIS LINE
                .retrieve()
                .bodyToMono(String.class);

        String response = responseMono.block();

        if (response != null) {
            return response;
        } else {
            throw new RuntimeException("Failed to fetch transactions for Basiq user");
        }
    }

    /**
     * Fetches account balance for a user
     */
    public String fetchAccountBalance(String userId) {
        ensureAuthenticated();

        Mono<String> responseMono = webClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path("/users/" + userId + "/accounts")
                        .queryParam("limit", 500)
                        .build())
                .header(HttpHeaders.ACCEPT, MediaType.APPLICATION_JSON_VALUE)
                .header(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken)
                .header("basiq-version", "3.0") // ← ADD THIS LINE
                .retrieve()
                .bodyToMono(String.class);

        String response = responseMono.block();

        if (response != null) {
            return response;
        } else {
            throw new RuntimeException("Failed to fetch account balance for Basiq user");
        }
    }
}