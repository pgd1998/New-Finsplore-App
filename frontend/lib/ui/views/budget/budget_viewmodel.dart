import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import '../../../api/budget_api.dart';
import '../../../api/transaction_api.dart';
import '../../../services/authentication_service.dart';
import '../../../app/app.locator.dart';

class BudgetViewModel extends BaseViewModel {
  final _budgetAPI = BudgetAPI();
  final _transactionAPI = TransactionAPI();
  final _authService = locator<AuthenticationService>();

  double _monthlyBudget = 0.0;
  double get monthlyBudget => _monthlyBudget;

  double _totalSpent = 0.0;
  double get totalSpent => _totalSpent;

  bool get hasBudget => _monthlyBudget > 0;

  double get remainingBudget => _monthlyBudget - _totalSpent;

  double get budgetProgress =>
      _monthlyBudget > 0 ? _totalSpent / _monthlyBudget : 0.0;

  List<Map<String, dynamic>> _spendingCategories = [];
  List<Map<String, dynamic>> get spendingCategories => _spendingCategories;

  Future<void> initialize() async {
    await loadBudgetData();
  }

  Future<void> loadBudgetData() async {
    setBusy(true);
    try {
      final userId = _authService.currentUser?['userId'] ?? 1;

      // Load budget
      try {
        final budgetResponse = await _budgetAPI.getBudget(userId);
        _monthlyBudget = budgetResponse['amount']?.toDouble() ?? 0.0;
      } catch (e) {
        // Budget not set yet
        _monthlyBudget = 0.0;
      }

      // Load current month spending
      await _loadCurrentMonthSpending();

      notifyListeners();
    } catch (e) {
      print('Error loading budget data: $e');
    } finally {
      setBusy(false);
    }
  }

  Future<void> _loadCurrentMonthSpending() async {
    try {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0);

      final summary = await _transactionAPI.getTransactionSummary(
        startDate: startOfMonth.toIso8601String().substring(0, 10),
        endDate: endOfMonth.toIso8601String().substring(0, 10),
      );

      _totalSpent = summary['totalExpenses']?.toDouble() ?? 0.0;

      // Mock spending categories for now
      _spendingCategories = [
        {
          'name': 'Groceries',
          'amount': _totalSpent * 0.3,
          'color': Colors.green,
        },
        {
          'name': 'Dining',
          'amount': _totalSpent * 0.2,
          'color': Colors.orange,
        },
        {
          'name': 'Transportation',
          'amount': _totalSpent * 0.15,
          'color': Colors.blue,
        },
        {
          'name': 'Entertainment',
          'amount': _totalSpent * 0.1,
          'color': Colors.purple,
        },
        {
          'name': 'Shopping',
          'amount': _totalSpent * 0.15,
          'color': Colors.red,
        },
        {
          'name': 'Other',
          'amount': _totalSpent * 0.1,
          'color': Colors.grey,
        },
      ];
    } catch (e) {
      // Mock data if API fails
      _totalSpent = 1250.0;
      _spendingCategories = [
        {
          'name': 'Groceries',
          'amount': 375.0,
          'color': Colors.green,
        },
        {
          'name': 'Dining',
          'amount': 250.0,
          'color': Colors.orange,
        },
        {
          'name': 'Transportation',
          'amount': 187.5,
          'color': Colors.blue,
        },
        {
          'name': 'Entertainment',
          'amount': 125.0,
          'color': Colors.purple,
        },
        {
          'name': 'Shopping',
          'amount': 187.5,
          'color': Colors.red,
        },
        {
          'name': 'Other',
          'amount': 125.0,
          'color': Colors.grey,
        },
      ];
    }
  }

  Future<void> setBudget(double amount) async {
    setBusy(true);
    try {
      final userId = _authService.currentUser?['userId'] ?? 1;
      await _budgetAPI.setBudget(userId: userId, amount: amount);
      _monthlyBudget = amount;
      notifyListeners();
    } catch (e) {
      print('Error setting budget: $e');
    } finally {
      setBusy(false);
    }
  }

  Future<void> refreshData() async {
    await loadBudgetData();
  }
}
