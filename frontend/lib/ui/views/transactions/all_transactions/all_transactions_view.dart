import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:finsplore/ui/common/app_text_styles.dart';
import 'all_transactions_viewmodel.dart';

class AllTransactionsView extends StackedView<AllTransactionsViewModel> {
  const AllTransactionsView({super.key});

  @override
  Widget builder(BuildContext context, AllTransactionsViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: Text('All Transactions')),
      body: Center(
        child: Text('All Transactions View - Coming Soon', style: AppTextStyles.heading),
      ),
    );
  }

  @override
  AllTransactionsViewModel viewModelBuilder(BuildContext context) => AllTransactionsViewModel();
}
