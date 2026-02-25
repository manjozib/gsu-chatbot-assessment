class ChatLog {
  final int id;
  final String sessionId;
  final String user;
  final String message;
  final DateTime timestamp;

  ChatLog({required this.id, required this.sessionId, required this.user, required this.message, required this.timestamp});

  factory ChatLog.fromJson(Map<String, dynamic> json) {
    return ChatLog(
      id: json['id'],
      sessionId: json['session_id'],
      user: json['user'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}