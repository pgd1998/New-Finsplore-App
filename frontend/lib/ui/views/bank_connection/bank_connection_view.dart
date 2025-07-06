import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:finsplore/ui/common/app_colors.dart';
import 'package:finsplore/services/bank_connection_service.dart';

class BankConnectionView extends StatefulWidget {
  final String authUrl;
  final VoidCallback? onConnectionSuccess;

  const BankConnectionView({
    super.key,
    required this.authUrl,
    this.onConnectionSuccess,
  });

  @override
  State<BankConnectionView> createState() => _BankConnectionViewState();
}

class _BankConnectionViewState extends State<BankConnectionView> {
  late final WebViewController _controller;
  final BankConnectionService _bankService = BankConnectionService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading state
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            
            // Check if connection was successful
            if (url.contains('success') || url.contains('complete')) {
              _handleConnectionSuccess();
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            // Handle success/cancel callbacks
            if (request.url.contains('success') || request.url.contains('complete')) {
              _handleConnectionSuccess();
              return NavigationDecision.prevent;
            }
            if (request.url.contains('cancel') || request.url.contains('error')) {
              _handleConnectionCancel();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.authUrl));
  }

  void _handleConnectionSuccess() async {
    await _bankService.handleConnectionSuccess();
    widget.onConnectionSuccess?.call();
    if (mounted) {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bank account connected successfully!'),
          backgroundColor: successColor,
        ),
      );
    }
  }

  void _handleConnectionCancel() {
    if (mounted) {
      Navigator.of(context).pop(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect Bank Account'),
        backgroundColor: kcPrimaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kcPrimaryColor),
              ),
            ),
        ],
      ),
    );
  }
}