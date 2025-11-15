import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String webhookUrl = 'https://httpbin.org/post';

  static Future<Map<String, dynamic>> submitNews(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(webhookUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          final jsonResponse =
              jsonDecode(response.body) as Map<String, dynamic>;
          return {
            'success': true,
            'statusCode': response.statusCode,
            'data': jsonResponse,
            'message': jsonResponse['message'] ?? 'News submitted successfully',
          };
        } catch (e) {
          return {
            'success': true,
            'statusCode': response.statusCode,
            'message':
                response.body.isNotEmpty
                    ? response.body
                    : 'News submitted successfully',
          };
        }
      } else {
        return {
          'success': false,
          'statusCode': response.statusCode,
          'message': 'Failed to submit news. Status: ${response.statusCode}',
          'error': response.body,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error submitting news: ${e.toString()}',
        'error': e.toString(),
      };
    }
  }
}
