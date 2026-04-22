class SecurityTip {
  final String title;
  final String description;

  const SecurityTip({
    required this.title,
    required this.description,
  });

  factory SecurityTip.fromJson(Map<String, dynamic> json) {
    return SecurityTip(
      title: json['title']?.toString() ?? 'Untitled Tip',
      description: json['body']?.toString() ?? 'No description available.',
    );
  }
}