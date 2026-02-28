class ChatLog {
  final int id;
  final String user;
  final String message;
  final DateTime timestamp;
  final bool isResponded;

  ChatLog({
    required this.id,
    required this.user,
    required this.message,
    required this.timestamp,
    required this.isResponded,
  });

  factory ChatLog.fromJson(Map<String, dynamic> json) {
    final response = json['response'] ?? '';

    final isResponded = !response.contains("I couldn't find an exact answer. Please check the FAQ page or rephrase your question (e.g., 'admissions', 'fees', 'programmes')") &&
        !response.startsWith('Did you mean:');

    return ChatLog(
      id: json['id'],
      user: json['user'] ?? 'Unknown',
      message: json['message'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
      isResponded: isResponded,
    );
  }
}
