import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../common/app_colors.dart';
import '../../common/ui_helpers.dart';
import 'bills_viewmodel.dart';

class BillsView extends StackedView<BillsViewModel> {
  const BillsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    BillsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Bills & Reminders',
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
          : Column(
              children: [
                // Summary Card
                Container(
                  margin: const EdgeInsets.all(16),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryItem(
                        'Total Bills',
                        '${viewModel.bills.length}',
                        Icons.receipt_long,
                        kcPrimaryColor,
                      ),
                      _buildSummaryItem(
                        'Due Soon',
                        '${viewModel.upcomingBills.length}',
                        Icons.schedule,
                        Colors.orange,
                      ),
                      _buildSummaryItem(
                        'Monthly Total',
                        '\$${viewModel.monthlyTotal.toStringAsFixed(0)}',
                        Icons.payments,
                        Colors.green,
                      ),
                    ],
                  ),
                ),
                
                // Bills List
                Expanded(
                  child: viewModel.bills.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: viewModel.bills.length,
                          itemBuilder: (context, index) {
                            final bill = viewModel.bills[index];
                            return _buildBillCard(context, bill, viewModel);
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBillDialog(context, viewModel),
        backgroundColor: kcPrimaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSummaryItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        verticalSpaceSmall,
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          verticalSpaceMedium,
          Text(
            'No Bills Added Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          verticalSpaceSmall,
          Text(
            'Tap the + button to add your first bill',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillCard(
    BuildContext context,
    Map<String, dynamic> bill,
    BillsViewModel viewModel,
  ) {
    final isOverdue = viewModel.isBillOverdue(bill);
    final isDueSoon = viewModel.isBillDueSoon(bill);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOverdue 
              ? Colors.red 
              : isDueSoon 
                  ? Colors.orange 
                  : Colors.grey[300]!,
          width: isOverdue || isDueSoon ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: isOverdue 
              ? Colors.red[100] 
              : isDueSoon 
                  ? Colors.orange[100] 
                  : kcPrimaryColor.withOpacity(0.1),
          child: Icon(
            Icons.receipt,
            color: isOverdue 
                ? Colors.red 
                : isDueSoon 
                    ? Colors.orange 
                    : kcPrimaryColor,
          ),
        ),
        title: Text(
          bill['name'] ?? 'Unknown Bill',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpaceTiny,
            Text(
              'Amount: \$${bill['amount']?.toStringAsFixed(2) ?? '0.00'}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            Text(
              'Due: ${viewModel.formatDate(bill['nextDueDate'])}',
              style: TextStyle(
                color: isOverdue 
                    ? Colors.red 
                    : isDueSoon 
                        ? Colors.orange 
                        : Colors.grey[600],
                fontSize: 14,
                fontWeight: isOverdue || isDueSoon 
                    ? FontWeight.w600 
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                _showEditBillDialog(context, viewModel, bill);
                break;
              case 'delete':
                _showDeleteConfirmation(context, viewModel, bill);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddBillDialog(BuildContext context, BillsViewModel viewModel) {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add New Bill'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Bill Name',
                  hintText: 'e.g., Electricity Bill',
                ),
              ),
              verticalSpaceSmall,
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  hintText: '0.00',
                  prefixText: '\$',
                ),
              ),
              verticalSpaceSmall,
              ListTile(
                title: const Text('Due Date'),
                subtitle: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() => selectedDate = date);
                  }
                },
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
                if (nameController.text.isNotEmpty && amountController.text.isNotEmpty) {
                  viewModel.addBill(
                    nameController.text,
                    double.tryParse(amountController.text) ?? 0.0,
                    selectedDate,
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kcPrimaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add Bill'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditBillDialog(
    BuildContext context,
    BillsViewModel viewModel,
    Map<String, dynamic> bill,
  ) {
    final nameController = TextEditingController(text: bill['name']);
    final amountController = TextEditingController(text: bill['amount']?.toString());
    DateTime selectedDate = DateTime.tryParse(bill['nextDueDate'] ?? '') ?? DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Bill'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Bill Name',
                ),
              ),
              verticalSpaceSmall,
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '\$',
                ),
              ),
              verticalSpaceSmall,
              ListTile(
                title: const Text('Due Date'),
                subtitle: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() => selectedDate = date);
                  }
                },
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
                if (nameController.text.isNotEmpty && amountController.text.isNotEmpty) {
                  viewModel.updateBill(
                    bill['id'],
                    nameController.text,
                    double.tryParse(amountController.text) ?? 0.0,
                    selectedDate,
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kcPrimaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    BillsViewModel viewModel,
    Map<String, dynamic> bill,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Bill'),
        content: Text('Are you sure you want to delete "${bill['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              viewModel.deleteBill(bill['id']);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  BillsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      BillsViewModel();
}
