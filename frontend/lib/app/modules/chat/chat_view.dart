import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chat_controller.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final ChatController c = Get.find();

  late final TextEditingController _messageController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final ChatController c = Get.find();
    _messageController = TextEditingController();
    _scrollController = ScrollController();

    // Auto-scroll
    ever(c.messages, (_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      c.createChat(text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leadingWidth: 80,

        leading: _appBarIcon(
          icon: Icons.settings_ethernet,
          label: "Config",
          onTap: () => Get.toNamed('/config'),
        ),

        centerTitle: true,
        title: _appBarIcon(
          icon: Icons.question_answer,
          label: "FAQ",
          onTap: () => Get.toNamed('/faq'),
        ),

        actions: [
          SizedBox(
            width: 80,
            child: _appBarIcon(
              icon: Icons.admin_panel_settings,
              label: "Admin",
              onTap: () => Get.toNamed('/admin/login'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'GSU SmartAssist',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          Expanded(
            child: Obx(
                  () => ListView.builder(
                controller: _scrollController,
                reverse: false, // New messages at bottom
                padding: const EdgeInsets.all(8),
                itemCount: c.messages.length,
                itemBuilder: (_, i) {
                  final messageMap = c.messages[i];
                  return _MessageBubble(message: messageMap);
                },
              ),
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }


  Widget _appBarIcon({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Theme.of(context).cardColor,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Type a question...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: _sendMessage,
            mini: true,
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Map<String, dynamic> message;

  const _MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final question = message['qstn']?.toString() ?? '';
    final answer = message['answer']?.toString() ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (question.isNotEmpty)
            _bubble(
              context,
              text: question,
              color: Colors.blue[50]!,
              isUser: true,
            ),

          if (answer.isNotEmpty)
            _bubble(
              context,
              text: answer,
              color: Colors.grey[200]!,
              isUser: false,
            ),
        ],
      ),
    );
  }

  Widget _bubble(
      BuildContext context, {
        required String text,
        required Color color,
        required bool isUser,
      }) {
    return Row(
      mainAxisAlignment:
      isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),

          // 👇 Enables select + copy + paste behavior
          child: SelectableText(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}

// class _MessageBubble extends StatelessWidget {
//   final Map<String, dynamic> message;
//
//   const _MessageBubble({required this.message});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start, // All messages left-aligned
//         children: [
//           Container(
//             constraints: BoxConstraints(
//               maxWidth: MediaQuery.of(context).size.width * 0.7,
//             ),
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             decoration: BoxDecoration(
//               color: Colors.grey[200],
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Text(
//               message['text'] as String? ?? '',
//               style: const TextStyle(fontSize: 16),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }