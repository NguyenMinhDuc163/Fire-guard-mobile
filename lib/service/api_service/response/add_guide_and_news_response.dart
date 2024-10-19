import 'dart:convert';

AddGuideAndNewsResponse addGuideAndNewsResponseFromJson(String str) =>
    AddGuideAndNewsResponse.fromJson(json.decode(str));

String addGuideAndNewsResponseToJson(AddGuideAndNewsResponse data) =>
    json.encode(data.toJson());

class AddGuideAndNewsResponse {
  AddGuideAndNewsResponse();

  factory AddGuideAndNewsResponse.fromJson(Map<String, dynamic> json) =>
      AddGuideAndNewsResponse();

  Map<String, dynamic> toJson() => {};
}
