import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:finsplore/ui/common/app_text_styles.dart';
import 'package:finsplore/ui/common/colors_helper.dart';
import 'tracking_viewmodel.dart';

class TrackingView extends StackedView<TrackingViewModel> {
  const TrackingView({super.key});

  @override
  Widget builder(BuildContext context, TrackingViewModel viewModel, Widget? child) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transaction Tracking',
              style: AppTextStyles.heading,
            ),
            SizedBox(height: 20),
            
            // Add Transaction Button
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to add transaction
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppThemeCombos.deepTeal,
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text(
                'Add New Transaction',
                style: TextStyle(color: AppThemeCombos.softWhite),
              ),
            ),
            
            SizedBox(height: 20),
            
            Text(
              'Recent Transactions',
              style: AppTextStyles.subheading,
            ),
            
            SizedBox(height: 12),
            
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppThemeCombos.aqua,
                        child: Icon(
                          index % 2 == 0 ? Icons.shopping_cart : Icons.restaurant,
                          color: AppThemeCombos.deepTeal,
                        ),
                      ),
                      title: Text('Transaction ${index + 1}'),
                      subtitle: Text('Category • Today'),
                      trailing: Text(
                        '${index % 2 == 0 ? '-' : '+'}\$${(20 + index * 15).toStringAsFixed(2)}',
                        style: TextStyle(
                          color: index % 2 == 0 ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  TrackingViewModel viewModelBuilder(BuildContext context) => TrackingViewModel();
}
