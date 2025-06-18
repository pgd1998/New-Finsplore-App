import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../common/app_colors.dart';
import '../../common/ui_helpers.dart';
import 'budget_viewmodel.dart';

class BudgetView extends StackedView<BudgetViewModel> {
  const BudgetView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    BudgetViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Budget Management',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: kcPrimaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Budget Overview Card
                  _buildBudgetOverviewCard(viewModel),
                  
                  verticalSpaceMedium,
                  
                  // Progress Card
                  _buildProgressCard(viewModel),
                  
                  verticalSpaceMedium,
                  
                  // Quick Actions
                  _buildQuickActions(context, viewModel),
                  
                  verticalSpaceMedium,
                  
                  // Spending Breakdown
                  _buildSpendingBreakdown(viewModel),
                ],
              ),
            ),
    );
  }

  Widget _buildBudgetOverviewCard(BudgetViewModel viewModel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [kcPrimaryColor, kcPrimaryColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kcPrimaryColor.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Monthly Budget',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          verticalSpaceSmall,
          Text(
            viewModel.hasBudget 
                ? '\$${viewModel.monthlyBudget.toStringAsFixed(2)}'
                : 'Not Set',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (viewModel.hasBudget) ...[
            verticalSpaceSmall,
            Text(
              'Spent: \$${viewModel.totalSpent.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            Text(
              'Remaining: \$${viewModel.remainingBudget.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressCard(BudgetViewModel viewModel) {
    if (!viewModel.hasBudget) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              Icons.timeline,
              size: 48,
              color: Colors.grey[400],
            ),
            verticalSpaceSmall,
            const Text(
              'Set a budget to track your progress',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            verticalSpaceSmall,
            const Text(
              'Get insights into your spending habits and stay on track with your financial goals.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    final progress = viewModel.budgetProgress;
    final isOverBudget = progress > 1.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Budget Progress',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isOverBudget ? Colors.red : kcPrimaryColor,
                ),
              ),
            ],
          ),
          verticalSpaceSmall,
          LinearProgressIndicator(
            value: progress > 1.0 ? 1.0 : progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              isOverBudget ? Colors.red : kcPrimaryColor,
            ),
          ),
          verticalSpaceSmall,
          if (isOverBudget)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.red[600], size: 20),
                  horizontalSpaceSmall,
                  Expanded(
                    child: Text(
                      'You\'ve exceeded your budget by \$${(viewModel.totalSpent - viewModel.monthlyBudget).toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.red[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Text(
              'You have \$${viewModel.remainingBudget.toStringAsFixed(2)} left for this month',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, BudgetViewModel viewModel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          verticalSpaceMedium,
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Set Budget',
                  Icons.savings,
                  kcPrimaryColor,
                  () => _showSetBudgetDialog(context, viewModel),
                ),
              ),
              horizontalSpaceSmall,
              Expanded(
                child: _buildActionButton(
                  'View Details',
                  Icons.analytics,
                  Colors.blue,
                  () => _showBudgetDetails(context, viewModel),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            verticalSpaceTiny,
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpendingBreakdown(BudgetViewModel viewModel) {
    if (!viewModel.hasBudget || viewModel.spendingCategories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Spending Breakdown',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          verticalSpaceMedium,
          ...viewModel.spendingCategories.map((category) {
            final percentage = (category['amount'] / viewModel.totalSpent) * 100;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        category['name'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '\$${category['amount'].toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  verticalSpaceTiny,
                  LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      category['color'] ?? kcPrimaryColor,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  void _showSetBudgetDialog(BuildContext context, BudgetViewModel viewModel) {
    final budgetController = TextEditingController(
      text: viewModel.hasBudget ? viewModel.monthlyBudget.toString() : '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(viewModel.hasBudget ? 'Update Budget' : 'Set Monthly Budget'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Monthly Budget Amount',
                hintText: '0.00',
                prefixText: '\$',
              ),
            ),
            verticalSpaceSmall,
            const Text(
              'Set a realistic monthly budget to track your spending and stay on top of your finances.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(budgetController.text);
              if (amount != null && amount > 0) {
                viewModel.setBudget(amount);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kcPrimaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text(viewModel.hasBudget ? 'Update' : 'Set Budget'),
          ),
        ],
      ),
    );
  }

  void _showBudgetDetails(BuildContext context, BudgetViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Budget Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Monthly Budget:', '\$${viewModel.monthlyBudget.toStringAsFixed(2)}'),
            _buildDetailRow('Total Spent:', '\$${viewModel.totalSpent.toStringAsFixed(2)}'),
            _buildDetailRow('Remaining:', '\$${viewModel.remainingBudget.toStringAsFixed(2)}'),
            const Divider(),
            Text(
              'Progress: ${(viewModel.budgetProgress * 100).toStringAsFixed(1)}%',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  @override
  BudgetViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      BudgetViewModel();
}
