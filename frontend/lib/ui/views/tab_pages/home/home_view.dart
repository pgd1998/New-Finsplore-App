import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:finsplore/ui/common/app_text_styles.dart';
import 'package:finsplore/ui/common/colors_helper.dart';
import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppThemeCombos.aqua,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back!',
                    style: AppTextStyles.heading.copyWith(
                      color: AppThemeCombos.deepTeal,
                    ),
                  ),
                  Text(
                    'Track your financial journey',
                    style: AppTextStyles.body,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            
            // Summary Cards
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Income',
                    '\$2,450.00',
                    Icons.arrow_upward,
                    Colors.green,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    'Expenses',
                    '\$1,890.00',
                    Icons.arrow_downward,
                    Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            
            // Recent Transactions
            Text(
              'Recent Transactions',
              style: AppTextStyles.subheading,
            ),
            SizedBox(height: 12),
            
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return _buildTransactionItem(
                  'Transaction ${index + 1}',
                  '\$${(50 + index * 25).toStringAsFixed(2)}',
                  Icons.shopping_bag,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String amount, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
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
              SizedBox(width: 8),
              Text(title, style: AppTextStyles.label),
            ],
          ),
          SizedBox(height: 8),
          Text(amount, style: AppTextStyles.bodyBold),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(String title, String amount, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppThemeCombos.deepTeal),
          SizedBox(width: 12),
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
