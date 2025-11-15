import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_news/services/api_service.dart';

class NewsController extends GetxController {
  final newsType = 'News URL'.obs;
  final newsInput = ''.obs;
  final category = ''.obs;
  final isLoading = false.obs;

  final List<String> newsTypes = ['News URL', 'News Heading', 'News RSS'];

  final List<String> categories = [
    'Politics',
    'Business & Finance',
    'Crime & Public Safety',
    'Weather & Natural Disasters',
    'Health & Medicine',
    'Science & Technology',
    'Sports',
    'Entertainment & Culture',
    'Lifestyle & Society',
  ];

  void setNewsType(String? value) {
    if (value != null) {
      newsType.value = value;
      newsInput.value = ''; // Clear input when type changes
    }
  }

  void setNewsInput(String value) {
    newsInput.value = value;
  }

  void setCategory(String? value) {
    if (value != null) {
      category.value = value;
    }
  }

  String getNewsInputLabel() {
    switch (newsType.value) {
      case 'News URL':
        return 'Enter News URL';
      case 'News Heading':
        return 'Enter News Heading';
      case 'News RSS':
        return 'Enter News RSS Feed';
      default:
        return 'Enter News Input';
    }
  }

  String getNewsInputHint() {
    switch (newsType.value) {
      case 'News URL':
        return 'https://news.com/article';
      case 'News Heading':
        return 'Enter the news headline';
      case 'News RSS':
        return 'https://news.com/rss';
      default:
        return 'Enter value';
    }
  }

  String? validateNewsInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter ${newsType.value.toLowerCase()}';
    }

    if (newsType.value == 'News URL' || newsType.value == 'News RSS') {
      if (!value.startsWith('http://') && !value.startsWith('https://')) {
        return 'Please enter a valid URL';
      }
    }

    return null;
  }

  String? validateCategory(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a category';
    }
    return null;
  }

  Future<Map<String, dynamic>?> submitNews(BuildContext context) async {
    if (newsInput.value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter news input'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return null;
    }

    if (category.value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return null;
    }

    isLoading.value = true;

    try {
      final jsonData = {
        'news_type': newsType.value,
        'news_value': newsInput.value.trim(),
        'category': category.value,
      };

      final response = await ApiService.submitNews(jsonData);

      isLoading.value = false;
      return response;
    } catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      return null;
    }
  }

  void resetForm() {
    newsType.value = 'News URL';
    newsInput.value = '';
    category.value = '';
  }
}
