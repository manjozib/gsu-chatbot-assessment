import 'package:flutter/material.dart';

import '../admin/dashboard/admin_dashboard_controller.dart';
import 'faq_list_widget.dart';
import 'package:get/get.dart';

class FaqView extends StatefulWidget {
  const FaqView({super.key});

  @override
  State<FaqView> createState() => _FaqViewState();
}

class _FaqViewState extends State<FaqView> {

  late final AdminManagementController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AdminManagementController>();
    // Load initial data
    _refreshFaqs();
  }

  Future<void> _refreshFaqs() async {
    await controller.fetchFaqs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 70,
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.question_answer, size: 28),
            SizedBox(height: 4),
            Text(
              "Frequently Asked Questions",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: FaqsListWidget(
        controller: controller,
        onRefresh: _refreshFaqs,
        canEdit: false,
        canDelete: false,
      ),
    );
  }
}
