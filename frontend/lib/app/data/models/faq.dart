class Faq {
  final int id;
  final String question;
  final String answer;
  final String keywords;

  Faq({required this.id, required this.question, required this.answer, required this.keywords});

  factory Faq.fromJson(Map<String, dynamic> json) {
    return Faq(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
      keywords: json['keywords'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'question': question,
    'answer': answer,
    'keywords': keywords,
  };
}