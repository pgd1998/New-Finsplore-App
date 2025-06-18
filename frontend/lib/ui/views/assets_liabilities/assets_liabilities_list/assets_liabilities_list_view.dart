import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'assets_liabilities_list_viewmodel.dart';

class AssetsLiabilitiesListView extends StackedView<AssetsLiabilitiesListViewModel> {
  const AssetsLiabilitiesListView({super.key});

  @override
  Widget builder(BuildContext context, AssetsLiabilitiesListViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: Text('Assets & Liabilities')),
      body: Center(child: Text('Assets & Liabilities List - Coming Soon')),
    );
  }

  @override
  AssetsLiabilitiesListViewModel viewModelBuilder(BuildContext context) => AssetsLiabilitiesListViewModel();
}
