import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../api/chat_api.dart';
import '../../../services/authentication_service.dart';
import '../../../app/app.locator.dart';

class AIAssistantViewModel extends BaseViewModel {
  final _chatAPI = ChatAPI();
  final _authService = locator<AuthenticationService>();
  
  final TextEditingController messageController = TextEditingController();
  
  List<Map<String, dynamic>> _messages = [];
  List<Map<String, dynamic>> get messages => _messages;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    
    // Add user message
    _addMessage(text, isUser: true);
    messageController.clear();
    notifyListeners();
    
    setBusy(true);
    try {
      final userId = _authService.currentUser?.id ?? 1;
      final response = await _chatAPI.sendMessage(
        userId: userId,
        message: text,
      );
      
      // Add AI response
      _addMessage(response, isUser: false);
    } catch (e) {
      _addMessage(
        'Sorry, I encountered an error. Please try again later.',
        isUser: false,
      );
    } finally {
      setBusy(false);
    }
  }

  Future<void> sendQuickMessage(String message) async {
    await sendMessage(message);
  }

  Future<void> sendBillReminder(String message) async {
    _addMessage(message, isUser: true);
    messageController.clear();
    notifyListeners();
    
    setBusy(true);
    try {
      final userId = _authService.currentUser?.id ?? 1;
      final response = await _chatAPI.sendBillReminder(
        userId: userId,
        message: message,
      );
      
      _addMessage(response, isUser: false);
    } catch (e) {
      _addMessage(
        'Sorry, I couldn\'t process your bill reminder request.',
        isUser: false,
      );
    } finally {
      setBusy(false);
    }
  }

  Future<void> generateSuggestion(String message) async {
    _addMessage(message, isUser: true);
    messageController.clear();
    notifyListeners();
    
    setBusy(true);
    try {
      final userId = _authService.currentUser?.id ?? 1;
      final response = await _chatAPI.generateSuggestion(
        userId: userId,
        message: message,
      );
      
      _addMessage(response, isUser: false);
    } catch (e) {
      _addMessage(
        'Sorry, I couldn\'t generate a suggestion right now.',
        isUser: false,
      );
    } finally {
      setBusy(false);
    }
  }

  void _addMessage(String text, {required bool isUser}) {
    _messages.add({
      'text': text,
      'isUser': isUser,
      'timestamp': DateTime.now(),
    });
    notifyListeners();
  }

  void clearChat() {
    _messages.clear();
    messageController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}
