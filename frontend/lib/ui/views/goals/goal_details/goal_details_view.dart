import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'goal_details_viewmodel.dart';

class GoalDetailsView extends StackedView<GoalDetailsViewModel> {
  const GoalDetailsView({super.key});

  @override
  Widget builder(BuildContext context, GoalDetailsViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: Text('Goal Details')),
      body: Center(child: Text('Goal Details - Coming Soon')),
    );
  }

  @override
  GoalDetailsViewModel viewModelBuilder(BuildContext context) => GoalDetailsViewModel();
}
