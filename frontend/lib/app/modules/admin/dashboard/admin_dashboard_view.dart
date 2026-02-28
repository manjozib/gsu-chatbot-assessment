import 'package:flutter/material.dart';
import 'package:frontend/app/utils/time_formatter.dart';
import 'package:get/get.dart';
import '../../../models/faq.dart';
import '../../faq/faq_list_widget.dart';
import 'admin_dashboard_controller.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView>
    with TickerProviderStateMixin {
  late final AdminManagementController controller;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AdminManagementController>();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);

    // Load initial data
    _refreshFaqs();
    _refreshChatLogs();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      if (_tabController.index == 0) {
        _refreshFaqs();
      } else {
        _refreshChatLogs();
      }
    }
  }

  Future<void> _refreshFaqs() async {
    await controller.fetchFaqs();
  }

  Future<void> _refreshChatLogs() async {
    await controller.fetchChatLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
            'Admin Management',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.help), text: 'FAQs'),
            Tab(icon: Icon(Icons.chat), text: 'Chat Logs'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FaqsListWidget(
            controller: controller,
            onRefresh: _refreshFaqs,
            canEdit: true,
            canDelete: true,
            onEdit: (faq) => _showFaqDialog(controller, faq: faq),
            onDelete: (faq) => _showDeleteDialog(controller, faq),
          ),
          _buildChatLogsTab(),
        ],
      ),
      floatingActionButton: Builder(
        builder: (context) {
          if (_tabController.index != 0) return const SizedBox();
          return FloatingActionButton(
            onPressed: () => _showFaqDialog(controller),
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }
  Widget _buildChatLogsTab() {
    return Obx(() {
      if (controller.isLoadingChatLogs.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.chatLogs.isEmpty) {
        return const Center(child: Text('No chat logs available.'));
      }
      return RefreshIndicator(
        onRefresh: _refreshChatLogs,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.chatLogs.length,
          itemBuilder: (_, i) {
            final log = controller.chatLogs[i];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              color: log.isResponded ? Colors.green[50]: Colors.red[50] ,
              child: ListTile(
                leading: CircleAvatar(child: Text(log.user[0])),
                title: Text(log.user),
                subtitle: Text(log.message),
                trailing: Text(
                  TimeFormatter.format(log.timestamp),
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  void _showFaqDialog(AdminManagementController controller, {Faq? faq}) {
    final isEditing = faq != null;
    final questionCtrl = TextEditingController(text: faq?.question ?? '');
    final answerCtrl = TextEditingController(text: faq?.answer ?? '');
    final categoryCtrl = TextEditingController(text: faq?.category ?? '');
    final keywordsCtrl = TextEditingController(text: faq?.keywords ?? '');

    Get.dialog(
      AlertDialog(
        title: Text(isEditing ? 'Edit FAQ' : 'New FAQ'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: questionCtrl,
                decoration: const InputDecoration(labelText: 'Question'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: answerCtrl,
                decoration: const InputDecoration(labelText: 'Answer'),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: categoryCtrl,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: keywordsCtrl,
                decoration: const InputDecoration(labelText: 'Keywords (comma separated)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final newFaq = Faq(
                id: isEditing ? faq!.id : 0,
                question: questionCtrl.text.trim(),
                answer: answerCtrl.text.trim(),
                category: categoryCtrl.text.trim(),
                keywords: keywordsCtrl.text.trim(),
              );
              if (isEditing) {
                controller.updateFaq(faq!.id, newFaq);
              } else {
                controller.createFaq(newFaq);
              }
              Get.back();
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
          TextButton(
              onPressed: () => Get.back(), child: const Text('Cancel')),
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