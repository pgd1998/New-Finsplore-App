package com.finsplore.controller;

import com.finsplore.entity.Bill;
import com.finsplore.service.BillService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Optional;
import java.math.BigDecimal;
import com.finsplore.dto.BillDto;
import com.finsplore.entity.User;
import com.finsplore.repository.UserRepository;

@RestController
@RequestMapping("/api/bills")
public class BillController {

    @Autowired
    private BillService billService;

    @Autowired
    private UserRepository userRepository;

    @PostMapping("/set")
    public ResponseEntity<Bill> createBill(@RequestBody BillDto billDto) {
        // Fetch user by ID
        User user = userRepository.findById(billDto.getUserId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));

        // Convert DTO to Entity
        Bill bill = new Bill(
            billDto.getName(),
            BigDecimal.valueOf(billDto.getAmount()),
            Bill.BillFrequency.MONTHLY, // Default frequency
            billDto.getDate(),
            user
        );
        Bill savedBill = billService.saveBill(bill);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedBill);
    }

    @GetMapping("/{userId}")
    public ResponseEntity<List<Bill>> getAllBills(@PathVariable Long userId) {
        return ResponseEntity.ok(billService.getBillById(userId));
    }
    
    @DeleteMapping("/delete/{billId}")
    public ResponseEntity<Void> deleteBill(@PathVariable Long billId) {
        billService.deleteBillById(billId);
        return ResponseEntity.noContent().build(); // HTTP 204
    }
}
