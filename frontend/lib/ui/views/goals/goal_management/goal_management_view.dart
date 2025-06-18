import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:finsplore/ui/common/app_text_styles.dart';
import 'goal_management_viewmodel.dart';

class GoalManagementView extends StackedView<GoalManagementViewModel> {
  const GoalManagementView({super.key});

  @override
  Widget builder(BuildContext context, GoalManagementViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: Text('Goal Management')),
      body: Center(
        child: Text('Goal Management View - Coming Soon', style: AppTextStyles.heading),
      ),
    );
  }

  @override
  GoalManagementViewModel viewModelBuilder(BuildContext context) => GoalManagementViewModel();
}
