import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:finsplore/ui/common/app_colors.dart';
import 'package:finsplore/ui/common/app_text_styles.dart';
import 'package:finsplore/services/bank_connection_service.dart';
import 'package:finsplore/ui/views/bank_connection/bank_connection_view.dart';

class BankConnectionCard extends StatefulWidget {
  final VoidCallback? onConnectionSuccess;

  const BankConnectionCard({
    super.key,
    this.onConnectionSuccess,
  });

  @override
  State<BankConnectionCard> createState() => _BankConnectionCardState();
}

class _BankConnectionCardState extends State<BankConnectionCard> {
  final BankConnectionService _bankService = BankConnectionService();
  bool _isLoading = false;

  Future<void> _connectToBank() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authUrl = await _bankService.generateBankConnectionLink();
      
      if (authUrl != null && mounted) {
        final result = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (context) => BankConnectionView(
              authUrl: authUrl,
              onConnectionSuccess: widget.onConnectionSuccess,
            ),
          ),
        );

        if (result == true && widget.onConnectionSuccess != null) {
          widget.onConnectionSuccess!();
        }
      } else {
        _showError('Failed to generate bank connection link. Please try again.');
      }
    } catch (e) {
      _showError('Error connecting to bank: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6366F1).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.account_balance,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Connect Your Bank',
                        style: AppTextStyles.heading.copyWith(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Securely link your bank accounts',
                        style: AppTextStyles.body.copyWith(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Get real-time access to your transactions, balances, and spending insights by connecting your bank accounts through our secure partner Basiq.',
              style: AppTextStyles.body.copyWith(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                _buildFeature(Icons.security, 'Bank-level security'),
                const SizedBox(width: 16),
                _buildFeature(Icons.sync, 'Real-time sync'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildFeature(Icons.insights, 'Smart insights'),
                const SizedBox(width: 16),
                _buildFeature(Icons.lock, 'Read-only access'),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _connectToBank,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF6366F1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.link, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Connect Bank Account',
                            style: AppTextStyles.bodyBold.copyWith(
                              color: const Color(0xFF6366F1),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return Expanded(
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}