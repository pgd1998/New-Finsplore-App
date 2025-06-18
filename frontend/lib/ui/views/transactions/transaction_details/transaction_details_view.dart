import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'transaction_details_viewmodel.dart';

class TransactionDetailsView extends StackedView<TransactionDetailsViewModel> {
  const TransactionDetailsView({super.key});

  @override
  Widget builder(BuildContext context, TransactionDetailsViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: Text('Transaction Details')),
      body: Center(child: Text('Transaction Details - Coming Soon')),
    );
  }

  @override
  TransactionDetailsViewModel viewModelBuilder(BuildContext context) => TransactionDetailsViewModel();
}
