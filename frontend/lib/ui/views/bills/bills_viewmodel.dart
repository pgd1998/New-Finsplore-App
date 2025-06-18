import 'package:stacked/stacked.dart';
import '../../../api/bill_api.dart';
import '../../../services/authentication_service.dart';
import '../../../app/app.locator.dart';

class BillsViewModel extends BaseViewModel {
  final _billAPI = BillAPI();
  final _authService = locator<AuthenticationService>();

  List<Map<String, dynamic>> _bills = [];
  List<Map<String, dynamic>> get bills => _bills;

  List<Map<String, dynamic>> get upcomingBills {
    final now = DateTime.now();
    final nextWeek = now.add(const Duration(days: 7));

    return _bills.where((bill) {
      final dueDate = DateTime.tryParse(bill['nextDueDate'] ?? '');
      return dueDate != null &&
          dueDate.isAfter(now) &&
          dueDate.isBefore(nextWeek);
    }).toList();
  }

  double get monthlyTotal {
    return _bills.fold(0.0, (sum, bill) => sum + (bill['amount'] ?? 0.0));
  }

  Future<void> initialize() async {
    await loadBills();
  }

  Future<void> loadBills() async {
    setBusy(true);
    try {
      final userId = _authService.currentUser?['userId'] ?? 1;
      _bills = await _billAPI.getUserBills(userId);
      notifyListeners();
    } catch (e) {
      // Handle error - could show snackbar or dialog
      print('Error loading bills: $e');
    } finally {
      setBusy(false);
    }
  }

  Future<void> addBill(String name, double amount, DateTime dueDate) async {
    setBusy(true);
    try {
      final userId = _authService.currentUser?['userId'] ?? 1;
      await _billAPI.createBill(
        userId: userId,
        name: name,
        amount: amount,
        date: dueDate.toIso8601String().substring(0, 10), // YYYY-MM-DD format
      );
      await loadBills(); // Refresh the list
    } catch (e) {
      print('Error adding bill: $e');
    } finally {
      setBusy(false);
    }
  }

  Future<void> updateBill(
      int billId, String name, double amount, DateTime dueDate) async {
    setBusy(true);
    try {
      // For now, we'll delete and recreate since backend doesn't have update endpoint
      await deleteBill(billId);
      await addBill(name, amount, dueDate);
    } catch (e) {
      print('Error updating bill: $e');
    } finally {
      setBusy(false);
    }
  }

  Future<void> deleteBill(int billId) async {
    setBusy(true);
    try {
      await _billAPI.deleteBill(billId);
      await loadBills(); // Refresh the list
    } catch (e) {
      print('Error deleting bill: $e');
    } finally {
      setBusy(false);
    }
  }

  bool isBillOverdue(Map<String, dynamic> bill) {
    final dueDate = DateTime.tryParse(bill['nextDueDate'] ?? '');
    if (dueDate == null) return false;
    return dueDate.isBefore(DateTime.now());
  }

  bool isBillDueSoon(Map<String, dynamic> bill) {
    final dueDate = DateTime.tryParse(bill['nextDueDate'] ?? '');
    if (dueDate == null) return false;
    final now = DateTime.now();
    final threeDaysFromNow = now.add(const Duration(days: 3));
    return dueDate.isAfter(now) && dueDate.isBefore(threeDaysFromNow);
  }

  String formatDate(String? dateString) {
    if (dateString == null) return 'Unknown';
    final date = DateTime.tryParse(dateString);
    if (date == null) return 'Unknown';
    return '${date.day}/${date.month}/${date.year}';
  }
}
