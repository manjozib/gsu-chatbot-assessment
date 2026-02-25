
import 'package:get/get.dart';
import '../modules/admin/dashboard/admin_dashboard_view.dart';
import '../modules/chat/chat_view.dart';
import '../modules/faq/faq_view.dart';
import '../modules/admin/login/admin_login_view.dart';

class AppPages {
  static final routes = [
    GetPage(name: '/chat', page: () => ChatView()),
    GetPage(name: '/faqs', page: () => FaqView()),
    GetPage(name: '/admin/login', page: () => AdminLoginView()),
    GetPage(name: '/admin/dashboard', page: () => AdminDashboardView()),
  ];
}
