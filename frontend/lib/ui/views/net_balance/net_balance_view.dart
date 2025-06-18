import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:finsplore/ui/common/app_text_styles.dart';
import 'net_balance_viewmodel.dart';

class NetBalanceView extends StackedView<NetBalanceViewModel> {
  const NetBalanceView({super.key});

  @override
  Widget builder(BuildContext context, NetBalanceViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: Text('Net Balance')),
      body: Center(
        child: Text('Net Balance View - Coming Soon', style: AppTextStyles.heading),
      ),
    );
  }

  @override
  NetBalanceViewModel viewModelBuilder(BuildContext context) => NetBalanceViewModel();
}
