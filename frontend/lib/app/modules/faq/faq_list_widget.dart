import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FaqsListWidget extends StatelessWidget {
  final dynamic controller;
  final Future<void> Function() onRefresh;
  final bool canEdit;
  final bool canDelete;
  final Function(dynamic faq)? onEdit;
  final Function(dynamic faq)? onDelete;

  const FaqsListWidget({
    super.key,
    required this.controller,
    required this.onRefresh,
    this.canEdit = true,
    this.canDelete = true,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingFaqs.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.faqs.isEmpty) {
        return const Center(child: Text('No FAQs yet. Tap + to add one.'));
      }

      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.faqs.length,
          itemBuilder: (_, i) {
            final faq = controller.faqs[i];

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      faq.question,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(faq.answer),
                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (canEdit)
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => onEdit?.call(faq),
                          ),

                        if (canDelete)
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => onDelete?.call(faq),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}