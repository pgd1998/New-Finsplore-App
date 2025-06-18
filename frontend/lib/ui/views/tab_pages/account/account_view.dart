import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:finsplore/ui/common/app_text_styles.dart';
import 'package:finsplore/ui/common/colors_helper.dart';
import 'account_viewmodel.dart';

class AccountView extends StackedView<AccountViewModel> {
  const AccountView({super.key});

  @override
  Widget builder(BuildContext context, AccountViewModel viewModel, Widget? child) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account',
              style: AppTextStyles.heading,
            ),
            SizedBox(height: 20),
            
            // Profile Section
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppThemeCombos.aqua.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppThemeCombos.deepTeal,
                    child: Icon(
                      Icons.person,
                      color: AppThemeCombos.softWhite,
                      size: 32,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          viewModel.userName,
                          style: AppTextStyles.subheading,
                        ),
                        Text(
                          viewModel.userEmail,
                          style: AppTextStyles.body,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: Navigate to edit profile
                    },
                    icon: Icon(Icons.edit, color: AppThemeCombos.deepTeal),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Menu Items
            _buildMenuItem(
              icon: Icons.account_balance,
              title: 'Bank Accounts',
              subtitle: 'Manage connected accounts',
              onTap: () {},
            ),
            
            _buildMenuItem(
              icon: Icons.security,
              title: 'Security',
              subtitle: 'Password and security settings',
              onTap: () {},
            ),
            
            _buildMenuItem(
              icon: Icons.notifications,
              title: 'Notifications',
              subtitle: 'Manage your notifications',
              onTap: () {},
            ),
            
            _buildMenuItem(
              icon: Icons.help,
              title: 'Help & Support',
              subtitle: 'Get help and contact support',
              onTap: () {},
            ),
            
            _buildMenuItem(
              icon: Icons.info,
              title: 'About',
              subtitle: 'App version and information',
              onTap: () {},
            ),
            
            SizedBox(height: 24),
            
            // Logout Button
            ElevatedButton(
              onPressed: viewModel.logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppThemeCombos.deepTeal),
        title: Text(title, style: AppTextStyles.body),
        subtitle: Text(subtitle, style: AppTextStyles.caption),
        trailing: Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  @override
  AccountViewModel viewModelBuilder(BuildContext context) => AccountViewModel();

  @override
  void onViewModelReady(AccountViewModel viewModel) {
    viewModel.initialize();
  }
}
