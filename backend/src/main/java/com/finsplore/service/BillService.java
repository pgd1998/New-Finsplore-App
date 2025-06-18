package com.finsplore.service;

import com.finsplore.entity.Bill;
import com.finsplore.repository.BillRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class BillService {

    @Autowired
    private BillRepository billRepository;

    public Bill saveBill(Bill bill) {
        return billRepository.save(bill);
    }

    public List<Bill> getBillById(Long id) {
        return billRepository.findByUserIdOrderByNextDueDateAsc(id);
    }

    public void deleteBillById(Long billId) {
        billRepository.deleteById(billId);
    }
}
