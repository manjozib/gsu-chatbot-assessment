class Chat {
  final String message;
  final String sessionId;

  Chat({required this.message, required this.sessionId});

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
        message: json['message'],
        sessionId: json['sessionId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'sessionId': sessionId,
  };
}