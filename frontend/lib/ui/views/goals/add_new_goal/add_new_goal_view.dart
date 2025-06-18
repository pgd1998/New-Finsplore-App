import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'add_new_goal_viewmodel.dart';

class AddNewGoalView extends StackedView<AddNewGoalViewModel> {
  const AddNewGoalView({super.key});

  @override
  Widget builder(BuildContext context, AddNewGoalViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Goal')),
      body: Center(child: Text('Add New Goal - Coming Soon')),
    );
  }

  @override
  AddNewGoalViewModel viewModelBuilder(BuildContext context) => AddNewGoalViewModel();
}
