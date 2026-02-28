
import 'package:get/get.dart';
import '../modules/admin/dashboard/admin_dashboard_view.dart';
import '../modules/chat/chat_view.dart';
import '../modules/admin/login/admin_login_view.dart';
import '../modules/config/server_config_view.dart';
import '../modules/faq/faq_view.dart';

class AppPages {
  static final routes = [
    GetPage(name: '/chat', page: () => const ChatView()),
    GetPage(name: '/admin/login', page: () => const AdminLoginView()),
    GetPage(name: '/admin/dashboard', page: () => const AdminDashboardView()),
    GetPage(name: '/config', page: () => const ServerConfigView()),
    GetPage(name: '/faq', page: () => const FaqView()),
  ];
}
