import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../common/app_colors.dart';
import '../../common/ui_helpers.dart';
import 'ai_assistant_viewmodel.dart';

class AIAssistantView extends StackedView<AIAssistantViewModel> {
  const AIAssistantView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AIAssistantViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'AI Financial Assistant',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: kcPrimaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: viewModel.clearChat,
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Actions Header
          _buildQuickActions(viewModel),
          
          // Chat Messages
          Expanded(
            child: viewModel.messages.isEmpty
                ? _buildWelcomeScreen()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: viewModel.messages.length,
                    itemBuilder: (context, index) {
                      final message = viewModel.messages[index];
                      return _buildMessageBubble(message);
                    },
                  ),
          ),
          
          // Message Input
          _buildMessageInput(context, viewModel),
        ],
      ),
    );
  }

  Widget _buildQuickActions(AIAssistantViewModel viewModel) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          verticalSpaceSmall,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildQuickActionChip(
                  'Analyze Spending',
                  Icons.analytics,
                  () => viewModel.sendQuickMessage('Analyze my spending patterns'),
                ),
                horizontalSpaceSmall,
                _buildQuickActionChip(
                  'Budget Advice',
                  Icons.savings,
                  () => viewModel.sendQuickMessage('Give me budget advice'),
                ),
                horizontalSpaceSmall,
                _buildQuickActionChip(
                  'Save Money',
                  Icons.trending_down,
                  () => viewModel.sendQuickMessage('How can I save more money?'),
                ),
                horizontalSpaceSmall,
                _buildQuickActionChip(
                  'Investment Tips',
                  Icons.trending_up,
                  () => viewModel.sendQuickMessage('Give me investment advice'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionChip(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: kcPrimaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kcPrimaryColor.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: kcPrimaryColor),
            horizontalSpaceTiny,
            Text(
              title,
              style: TextStyle(
                color: kcPrimaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kcPrimaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.smart_toy,
                size: 64,
                color: kcPrimaryColor,
              ),
            ),
            verticalSpaceLarge,
            const Text(
              'Welcome to your AI Financial Assistant! 👋',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            verticalSpaceMedium,
            const Text(
              'I\'m here to help you with:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            verticalSpaceSmall,
            const Text(
              '• Analyzing your spending patterns\n'
              '• Creating and managing budgets\n'
              '• Providing personalized saving tips\n'
              '• Answering financial questions\n'
              '• Giving investment advice',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.left,
            ),
            verticalSpaceLarge,
            const Text(
              'Try the quick actions above or type a message below!',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isUser = message['isUser'] as bool;
    final text = message['text'] as String;
    final timestamp = message['timestamp'] as DateTime;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              backgroundColor: kcPrimaryColor,
              radius: 16,
              child: const Icon(
                Icons.smart_toy,
                color: Colors.white,
                size: 16,
              ),
            ),
            horizontalSpaceSmall,
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser ? kcPrimaryColor : Colors.white,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
                  bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  verticalSpaceTiny,
                  Text(
                    _formatTime(timestamp),
                    style: TextStyle(
                      color: isUser ? Colors.white70 : Colors.grey[600],
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            horizontalSpaceSmall,
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              radius: 16,
              child: const Icon(
                Icons.person,
                color: Colors.grey,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context, AIAssistantViewModel viewModel) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: viewModel.messageController,
                  decoration: const InputDecoration(
                    hintText: 'Ask me anything about your finances...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  maxLines: null,
                  onSubmitted: (text) {
                    if (text.trim().isNotEmpty) {
                      viewModel.sendMessage(text);
                    }
                  },
                ),
              ),
            ),
            horizontalSpaceSmall,
            Container(
              decoration: BoxDecoration(
                color: kcPrimaryColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: viewModel.isBusy 
                    ? null 
                    : () {
                        final text = viewModel.messageController.text.trim();
                        if (text.isNotEmpty) {
                          viewModel.sendMessage(text);
                        }
                      },
                icon: viewModel.isBusy
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  AIAssistantViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AIAssistantViewModel();
}
