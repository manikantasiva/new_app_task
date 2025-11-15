import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:test_news/controllers/news_controller.dart';

class NewsAddResponseBottomSheet extends StatelessWidget {
  final Map<String, dynamic> response;

  const NewsAddResponseBottomSheet({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    final isSuccess = response['success'] == true;

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Drag Handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Icon(
                      isSuccess ? Icons.check_circle : Icons.error,
                      color: isSuccess ? Colors.green : Colors.red,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isSuccess ? 'Success' : 'Error',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isSuccess ? Colors.green : Colors.red,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                        Get.find<NewsController>().resetForm();
                        context.go('/home');
                      },
                    ),
                  ],
                ),
              ),

              const Divider(),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status Code
                      _buildInfoRow(
                        'Status Code',
                        '${response['statusCode'] ?? 'N/A'}',
                        Icons.info_outline,
                      ),
                      const SizedBox(height: 20),

                      // Message
                      _buildInfoRow(
                        'Message',
                        response['message'] ?? 'No message',
                        Icons.message_outlined,
                      ),

                      // Response Data
                      if (response['data'] != null) ...[
                        const SizedBox(height: 24),
                        const Text(
                          'Response Data',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: SelectableText(
                            _formatJson(response['data']),
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],

                      // Error Details
                      if (response['error'] != null) ...[
                        const SizedBox(height: 24),
                        const Text(
                          'Error Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red[200]!),
                          ),
                          child: SelectableText(
                            response['error'].toString(),
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Footer Button
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Get.find<NewsController>().resetForm();
                      context.go('/home');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.deepPurple),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              SelectableText(value, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }

  String _formatJson(dynamic data) {
    if (data is Map || data is List) {
      // Try to format as JSON string
      try {
        final encoder = const JsonEncoder.withIndent('  ');
        return encoder.convert(data);
      } catch (e) {
        return data.toString();
      }
    }
    return data.toString();
  }
}
