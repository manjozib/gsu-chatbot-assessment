
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/faq.dart';
import 'admin_dashboard_controller.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminManagementController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Management'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.help), text: 'FAQs'),
              Tab(icon: Icon(Icons.chat), text: 'Chat Logs'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildFaqsTab(controller),
            _buildChatLogsTab(controller),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) {
            // Now we can safely use DefaultTabController.of(context)
            final tabController = DefaultTabController.of(context);
            if (tabController?.index != 0) return const SizedBox();
            return FloatingActionButton(
              onPressed: () => _showFaqDialog(controller),
              child: const Icon(Icons.add),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFaqsTab(AdminManagementController controller) {
    return Obx(() {
      if (controller.isLoadingFaqs.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.faqs.isEmpty) {
        return const Center(child: Text('No FAQs yet. Tap + to add one.'));
      }
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.faqs.length,
        itemBuilder: (_, i) {
          final faq = controller.faqs[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    faq.question,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(faq.answer),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showFaqDialog(controller, faq: faq),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _showDeleteDialog(controller, faq),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildChatLogsTab(AdminManagementController controller) {
    return Obx(() {
      if (controller.isLoadingChatLogs.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.chatLogs.isEmpty) {
        return const Center(child: Text('No chat logs available.'));
      }
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.chatLogs.length,
        itemBuilder: (_, i) {
          final log = controller.chatLogs[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(child: Text(log.user[0])),
              title: Text(log.user),
              subtitle: Text(log.message),
              trailing: Text(
                '${log.timestamp.hour}:${log.timestamp.minute}',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          );
        },
      );
    });
  }

  void _showFaqDialog(AdminManagementController controller, {Faq? faq}) {
    final isEditing = faq != null;
    final questionCtrl = TextEditingController(text: faq?.question ?? '');
    final answerCtrl = TextEditingController(text: faq?.answer ?? '');

    Get.dialog(
      AlertDialog(
        title: Text(isEditing ? 'Edit FAQ' : 'New FAQ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: questionCtrl,
              decoration: const InputDecoration(labelText: 'Question'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: answerCtrl,
              decoration: const InputDecoration(labelText: 'Answer'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final newFaq = Faq(
                id: isEditing ? faq!.id : 0,
                question: questionCtrl.text.trim(),
                answer: answerCtrl.text.trim(),
                keywords: '',
              );
              if (isEditing) {
                controller.updateFaq(faq!.id, newFaq);
              } else {
                controller.createFaq(newFaq);
              }
            },
            child: Text(isEditing ? 'Update' : 'Create'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(AdminManagementController controller, Faq faq) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete FAQ'),
        content: Text('Are you sure you want to delete "${faq.question}"?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              controller.deleteFaq(faq.id);
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}