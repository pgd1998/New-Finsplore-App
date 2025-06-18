import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:finsplore/ui/common/app_text_styles.dart';
import 'package:finsplore/ui/common/colors_helper.dart';
import 'analytics_viewmodel.dart';

class AnalyticsView extends StackedView<AnalyticsViewModel> {
  const AnalyticsView({super.key});

  @override
  Widget builder(BuildContext context, AnalyticsViewModel viewModel, Widget? child) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Financial Analytics',
              style: AppTextStyles.heading,
            ),
            SizedBox(height: 20),
            
            // Chart placeholder
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppThemeCombos.aqua.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppThemeCombos.deepTeal),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bar_chart,
                      size: 48,
                      color: AppThemeCombos.deepTeal,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Analytics Chart Coming Soon',
                      style: AppTextStyles.body,
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            Text(
              'Quick Stats',
              style: AppTextStyles.subheading,
            ),
            
            SizedBox(height: 12),
            
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildStatCard('Total Balance', '\$560.00', Icons.account_balance_wallet),
                  _buildStatCard('Monthly Savings', '\$320.00', Icons.savings),
                  _buildStatCard('Top Category', 'Food & Dining', Icons.restaurant),
                  _buildStatCard('Goals Progress', '75%', Icons.trending_up),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppThemeCombos.deepTeal, size: 32),
          SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.bodyBold,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  AnalyticsViewModel viewModelBuilder(BuildContext context) => AnalyticsViewModel();
}
