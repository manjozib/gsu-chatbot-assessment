class ChatLog {
  final int id;
  final String user;
  final String message;
  final DateTime timestamp;
  // Add other fields as needed (e.g., sessionId, role, etc.)

  ChatLog({
    required this.id,
    required this.user,
    required this.message,
    required this.timestamp,
  });

  factory ChatLog.fromJson(Map<String, dynamic> json) {
    return ChatLog(
      id: json['id'],
      user: json['user'] ?? 'Unknown',
      message: json['message'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}