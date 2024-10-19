import 'dart:convert';

List<AddGuideAndNewsRequest> addGuideAndNewsRequestFromJson(String str) =>
    List<AddGuideAndNewsRequest>.from(
        json.decode(str).map((x) => AddGuideAndNewsRequest.fromJson(x)));

String addGuideAndNewsRequestToJson(List<AddGuideAndNewsRequest> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AddGuideAndNewsRequest {
  AddGuideAndNewsRequest({
    this.title,
    this.type,
    this.url,
    this.content,
    this.category,
  });

  final String? title;
  final String? type;
  final String? url;
  final String? content;
  final String? category;

  factory AddGuideAndNewsRequest.fromJson(Map<String, dynamic> json) =>
      AddGuideAndNewsRequest(
        title: json["title"],
        type: json["type"],
        url: json["url"],
        content: json["content"],
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
    "title": title,
    "type": type,
    "url": url,
    "content": content,
    "category": category,
  };
}
