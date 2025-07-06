import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:finsplore/ui/common/app_colors.dart';
import 'package:finsplore/ui/common/app_text_styles.dart';
import 'package:finsplore/ui/common/colors_helper.dart';
import 'package:finsplore/model/connected_account.dart';

class ConnectedAccountsCard extends StatelessWidget {
  final List<ConnectedAccount> accounts;
  final VoidCallback onRefresh;
  final VoidCallback onAddAccount;

  const ConnectedAccountsCard({
    super.key,
    required this.accounts,
    required this.onRefresh,
    required this.onAddAccount,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppThemeCombos.deepTeal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.account_balance,
                        color: AppThemeCombos.deepTeal,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Connected Banks',
                      style: AppTextStyles.subheading.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppThemeCombos.deepTeal,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: onRefresh,
                      icon: const Icon(
                        Icons.refresh,
                        color: AppThemeCombos.teal,
                      ),
                      tooltip: 'Refresh data',
                    ),
                    IconButton(
                      onPressed: onAddAccount,
                      icon: const Icon(
                        Icons.add_circle_outline,
                        color: AppThemeCombos.teal,
                      ),
                      tooltip: 'Add another bank',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...accounts.map((account) => _buildAccountItem(account)),
            if (accounts.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.account_balance_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No connected accounts yet',
                        style: AppTextStyles.body.copyWith(
                          color: Colors.grey[600],
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

  Widget _buildAccountItem(ConnectedAccount account) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppThemeCombos.aqua.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppThemeCombos.aqua.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppThemeCombos.deepTeal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              color: AppThemeCombos.deepTeal,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.displayName,
                  style: AppTextStyles.bodyBold.copyWith(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${account.bankDisplay} • ${account.accountDisplay}',
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
                account.balanceDisplay,
                style: AppTextStyles.bodyBold.copyWith(
                  color: AppThemeCombos.deepTeal,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: account.isActive ? successColor : warningColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  account.isActive ? 'Active' : 'Inactive',
                  style: const TextStyle(
                    color: Colors.white,
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
}