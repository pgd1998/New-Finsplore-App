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
              .map((data) =>
                  ConnectedAccount.fromJson(data as Map<String, dynamic>))
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
      print('Attempting to generate bank connection link...');

      // Check if user is authenticated first
      if (!_basiqApi.isAuthenticated) {
        print('ERROR: User not authenticated. Please sign in first.');
        throw Exception('Please sign in to connect your bank account');
      }

      // First ensure user has a Basiq user account
      print('Creating Basiq user...');
      final userResult = await _basiqApi.createBasiqUser();
      print('Create user result: $userResult');

      if (userResult == null) {
        throw Exception(
            'Failed to create Basiq user. Please check your connection and try again.');
      }

      // Then generate auth link
      print('Generating auth link...');
      final authResult = await _basiqApi.generateAuthLink();
      print('Auth link result: $authResult');

      if (authResult != null && authResult['data'] != null) {
        final authLink = authResult['data']?['authLink'] as String?;
        if (authLink != null) {
          print('✅ Successfully generated auth link: $authLink');
          return authLink;
        }
      }

      throw Exception(
          'Backend did not return a valid auth link. Please try again.');
    } catch (e) {
      print('❌ Error generating bank connection link: $e');
      rethrow; // Re-throw so the UI can show the specific error
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
