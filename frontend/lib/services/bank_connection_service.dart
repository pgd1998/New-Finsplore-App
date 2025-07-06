import 'package:finsplore/api/basiq_api.dart';
import 'package:finsplore/model/connected_account.dart';
import 'package:finsplore/model/result.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BankConnectionService {
  final BasiqApi _basiqApi = BasiqApi();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Check if user has connected bank accounts
  Future<bool> hasConnectedAccounts() async {
    try {
      final result = await _basiqApi.getConnectedAccounts();
      if (result != null) {
        final accounts = result['data']?['accounts'] as List?;
        return accounts != null && accounts.isNotEmpty;
      }
      return false;
    } catch (e) {
      print('Error checking connected accounts: $e');
      return false;
    }
  }

  /// Get list of connected bank accounts
  Future<List<ConnectedAccount>> getConnectedAccounts() async {
    try {
      final result = await _basiqApi.getConnectedAccounts();
      if (result != null) {
        final accountsData = result['data']?['accounts'] as List?;
        if (accountsData != null) {
          return accountsData
              .map((data) => ConnectedAccount.fromJson(data as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching connected accounts: $e');
      return [];
    }
  }

  /// Generate authentication link for bank connection
  Future<String?> generateBankConnectionLink() async {
    try {
      // First ensure user has a Basiq user account
      await _basiqApi.createBasiqUser();
      
      // Then generate auth link
      final result = await _basiqApi.generateAuthLink();
      if (result != null) {
        return result['data']?['authLink'] as String?;
      }
      return null;
    } catch (e) {
      print('Error generating bank connection link: $e');
      return null;
    }
  }

  /// Refresh bank data (transactions, balances)
  Future<bool> refreshBankData() async {
    try {
      final result = await _basiqApi.refreshBankData();
      return result != null;
    } catch (e) {
      print('Error refreshing bank data: $e');
      return false;
    }
  }

  /// Store connection status locally
  Future<void> setConnectionStatus(bool isConnected) async {
    await _secureStorage.write(
      key: 'bank_connected',
      value: isConnected.toString(),
    );
  }

  /// Get stored connection status
  Future<bool> getConnectionStatus() async {
    final status = await _secureStorage.read(key: 'bank_connected');
    return status == 'true';
  }

  /// Handle successful bank connection callback
  Future<void> handleConnectionSuccess() async {
    await setConnectionStatus(true);
    await refreshBankData();
  }
}