import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:test_news/controllers/news_controller.dart';
import 'package:test_news/widgets/response_bottom_sheet.dart';

class AddNewsScreen extends StatelessWidget {
  const AddNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NewsController controller = Get.put(NewsController());
    final _formKey = GlobalKey<FormState>();
    final _newsInputController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        title: const Text('Add News'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              // News Details Section
              const Text(
                'News Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 16),

              // News Type Dropdown
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.newsType.value,
                  decoration: InputDecoration(
                    labelText: 'News Type',
                    prefixIcon: const Icon(Icons.article),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  items:
                      controller.newsTypes.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                  onChanged: (value) {
                    controller.setNewsType(value);
                    _newsInputController.clear();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select news type';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => TextFormField(
                  controller: _newsInputController,
                  onChanged: (value) => controller.setNewsInput(value),
                  decoration: InputDecoration(
                    labelText: controller.getNewsInputLabel(),
                    hintText: controller.getNewsInputHint(),
                    prefixIcon: const Icon(Icons.edit),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  keyboardType:
                      controller.newsType.value == 'News URL' ||
                              controller.newsType.value == 'News RSS'
                          ? TextInputType.url
                          : TextInputType.text,
                  validator: controller.validateNewsInput,
                ),
              ),
              const SizedBox(height: 32),

              // News Category Section
              const Text(
                'News Category',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              Obx(
                () => DropdownButtonFormField<String>(
                  value:
                      controller.category.value.isEmpty
                          ? null
                          : controller.category.value,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    hintText: 'Select a category',
                    prefixIcon: const Icon(Icons.category),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  items:
                      controller.categories.map((String cat) {
                        return DropdownMenuItem<String>(
                          value: cat,
                          child: Text(cat),
                        );
                      }).toList(),
                  onChanged: (value) => controller.setCategory(value),
                  validator: controller.validateCategory,
                ),
              ),
              const SizedBox(height: 40),

              // Submit Button
              Obx(
                () => ElevatedButton(
                  onPressed:
                      controller.isLoading.value
                          ? null
                          : () async {
                            if (_formKey.currentState!.validate()) {
                              final response = await controller.submitNews(
                                context,
                              );
                              if (response != null) {
                                _showResponseBottomSheet(context, response);
                              }
                            }
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      controller.isLoading.value
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : const Text(
                            'Submit to Webhook',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showResponseBottomSheet(
    BuildContext context,
    Map<String, dynamic> response,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NewsAddResponseBottomSheet(response: response),
    );
  }
}
