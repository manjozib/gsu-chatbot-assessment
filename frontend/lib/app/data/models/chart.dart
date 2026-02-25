class Chat {
  final String message;
  final String sessionId;

  Chat({required this.message, required this.sessionId});

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
        message: json['message'],
        sessionId: json['session_id'],
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'session_id': sessionId,
  };
}