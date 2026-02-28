class ChatLog {
  final int id;
  final String user;
  final String message;
  final DateTime timestamp;
  final bool isResponded;
  // Add other fields as needed (e.g., sessionId, role, etc.)

  ChatLog({
    required this.id,
    required this.user,
    required this.message,
    required this.timestamp,
    required this.isResponded,
  });

  factory ChatLog.fromJson(Map<String, dynamic> json) {
    // Assuming 'response' is the key containing the AI's reply
    final response = json['response'] ?? '';

    // Determine if the response is valid (not a fallback message)
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
