import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:finsplore/ui/common/app_text_styles.dart';
import 'package:finsplore/ui/common/colors_helper.dart';
import 'package:finsplore/ui/common/app_colors.dart';
import 'package:animate_do/animate_do.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:finsplore/ui/widgets/bank_connection_card.dart';
import 'package:finsplore/ui/widgets/connected_accounts_card.dart';
import 'package:finsplore/services/bank_connection_service.dart';
import 'package:finsplore/model/connected_account.dart';
import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: backgroundGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section with Animation
              FadeInDown(
                duration: const Duration(milliseconds: 600),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppThemeCombos.deepTeal.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome Back!',
                                style: AppTextStyles.heading.copyWith(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Track your financial journey',
                                style: AppTextStyles.body.copyWith(
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.account_balance_wallet,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Bank Connection Section
              _BankConnectionSection(),
              const SizedBox(height: 24),
            
              // Quick Actions
              FadeInUp(
                duration: const Duration(milliseconds: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Actions',
                      style: AppTextStyles.subheading.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppThemeCombos.deepTeal,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildModernQuickActionCard(
                            'Bills',
                            Icons.receipt_long,
                            const Color(0xFF6366F1),
                            () => viewModel.navigateToBills(),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildModernQuickActionCard(
                            'Budget',
                            Icons.savings,
                            const Color(0xFF10B981),
                            () => viewModel.navigateToBudget(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildModernQuickActionCard(
                            'AI Assistant',
                            Icons.smart_toy,
                            const Color(0xFF8B5CF6),
                            () => viewModel.navigateToAI(),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildModernQuickActionCard(
                            'Goals',
                            Icons.flag,
                            const Color(0xFFF59E0B),
                            () => viewModel.navigateToGoals(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            
              // Summary Cards
              FadeInLeft(
                duration: const Duration(milliseconds: 1000),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildModernSummaryCard(
                        'Income',
                        '\$2,450.00',
                        Icons.trending_up,
                        successColor,
                        '+12.5%',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildModernSummaryCard(
                        'Expenses',
                        '\$1,890.00',
                        Icons.trending_down,
                        errorColor,
                        '-8.3%',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            
              // Recent Transactions
              FadeInRight(
                duration: const Duration(milliseconds: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Transactions',
                      style: AppTextStyles.subheading.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppThemeCombos.deepTeal,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return _buildModernTransactionItem(
                          'Transaction ${index + 1}',
                          '\$${(50 + index * 25).toStringAsFixed(2)}',
                          Icons.shopping_bag,
                          index,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernQuickActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTextStyles.label.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.label.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernSummaryCard(String title, String amount, IconData icon, Color color, String percentage) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFF8F9FA)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  percentage,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTextStyles.label.copyWith(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: AppTextStyles.bodyBold.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String amount, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(title, style: AppTextStyles.label),
            ],
          ),
          const SizedBox(height: 8),
          Text(amount, style: AppTextStyles.bodyBold),
        ],
      ),
    );
  }

  Widget _buildModernTransactionItem(String title, String amount, IconData icon, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFF8F9FA)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppThemeCombos.deepTeal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppThemeCombos.deepTeal, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Today • Shopping',
                  style: AppTextStyles.label.copyWith(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: AppTextStyles.bodyBold.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Expense',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(String title, String amount, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppThemeCombos.deepTeal),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title, style: AppTextStyles.body),
          ),
          Text(amount, style: AppTextStyles.bodyBold),
        ],
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();

  @override
  void onViewModelReady(HomeViewModel viewModel) {
    viewModel.loadData();
  }
}

class _BankConnectionSection extends StatefulWidget {
  @override
  _BankConnectionSectionState createState() => _BankConnectionSectionState();
}

class _BankConnectionSectionState extends State<_BankConnectionSection> {
  final BankConnectionService _bankService = BankConnectionService();
  bool _hasConnectedAccounts = false;
  List<ConnectedAccount> _connectedAccounts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBankConnectionStatus();
  }

  Future<void> _loadBankConnectionStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final hasAccounts = await _bankService.hasConnectedAccounts();
      if (hasAccounts) {
        final accounts = await _bankService.getConnectedAccounts();
        setState(() {
          _hasConnectedAccounts = true;
          _connectedAccounts = accounts;
        });
      } else {
        setState(() {
          _hasConnectedAccounts = false;
          _connectedAccounts = [];
        });
      }
    } catch (e) {
      print('Error loading bank connection status: $e');
      setState(() {
        _hasConnectedAccounts = false;
        _connectedAccounts = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleConnectionSuccess() async {
    await _loadBankConnectionStatus();
  }

  Future<void> _handleRefresh() async {
    final success = await _bankService.refreshBankData();
    if (success) {
      await _loadBankConnectionStatus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bank data refreshed successfully!'),
          backgroundColor: successColor,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to refresh bank data'),
          backgroundColor: errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppThemeCombos.deepTeal),
          ),
        ),
      );
    }

    if (_hasConnectedAccounts && _connectedAccounts.isNotEmpty) {
      return ConnectedAccountsCard(
        accounts: _connectedAccounts,
        onRefresh: _handleRefresh,
        onAddAccount: _handleConnectionSuccess,
      );
    } else {
      return BankConnectionCard(
        onConnectionSuccess: _handleConnectionSuccess,
      );
    }
  }
}
