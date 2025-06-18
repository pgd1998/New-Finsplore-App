import 'package:dio/dio.dart';
import 'simple_api_base.dart';

class ChatAPI extends SimpleApiBase {
  static const String _chatEndpoint = '/api/chat';

  /// Sends a general chat message to AI assistant
  Future<String> sendMessage({
    required int userId,
    required String message,
  }) async {
    try {
      final response = await dio.post(
        '$_chatEndpoint/send',
        data: {
          'userId': userId,
          'message': message,
        },
      );
      return response.data.toString();
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Sends a bill reminder request
  Future<String> sendBillReminder({
    required int userId,
    required String message,
  }) async {
    try {
      final response = await dio.post(
        '$_chatEndpoint/send/billReminder',
        data: {
          'userId': userId,
          'message': message,
        },
      );
      return response.data.toString();
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Generates a financial suggestion
  Future<String> generateSuggestion({
    required int userId,
    required String message,
  }) async {
    try {
      final response = await dio.post(
        '$_chatEndpoint/send/suggestion',
        data: {
          'userId': userId,
          'message': message,
        },
      );
      return response.data.toString();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      return Exception(
          'Chat API Error: ${error.response?.data?['message'] ?? error.message}');
    }
    return Exception('Unexpected error: $error');
  }
}
