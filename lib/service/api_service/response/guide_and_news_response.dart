class GuideAndNewsResponse {
  final int id;
  final String title;
  final String type;
  final String? url;
  final String? content;

  GuideAndNewsResponse({
    required this.id,
    required this.title,
    required this.type,
    this.url,
    this.content,
  });

  factory GuideAndNewsResponse.fromJson(Map<String, dynamic> json) {
    return GuideAndNewsResponse(
      id: json['id'] as int,
      title: json['title'] as String,
      type: json['type'] as String,
      url: json['url'] as String?,
      content: json['content'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "type": type,
    "url": url,
    "content": content,
  };
}
