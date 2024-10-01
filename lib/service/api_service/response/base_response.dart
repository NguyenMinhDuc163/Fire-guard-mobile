import 'dart:convert';

BaseResponse baseResponseFromJson(String str) => BaseResponse.fromJson(json.decode(str));

String baseResponseToJson(BaseResponse data) => json.encode(data.toJson());

class BaseResponse {
  BaseResponse({
    this.urlViewBody,
    this.responseCode,
    this.object,
    this.message,
    this.refreshedToken,
    this.baseResponseUrlViewBody,
    this.htmlContent,
    this.securityType,
  });

  final String? urlViewBody;
  final String? responseCode;
  final String? object;
  final dynamic? message;
  final dynamic? refreshedToken;
  final String? baseResponseUrlViewBody;
  final String? htmlContent;
  final dynamic? securityType;

  factory BaseResponse.fromJson(Map<String, dynamic> json) => BaseResponse(
    urlViewBody: json["Url_viewBody"] == null ? null : json["Url_viewBody"],
    responseCode: json["responseCode"] == null ? null : json["responseCode"],
    object: json["object"] == null ? null : json["object"],
    message: json["message"] == null ? null : json["message"],
    refreshedToken: json["refreshedToken"],
    baseResponseUrlViewBody: json["url_viewBody"] == null ? null : json["url_viewBody"],
    htmlContent: json["htmlContent"] == null ? null : json["htmlContent"],
    securityType: json["securityType"],
  );

  Map<String, dynamic> toJson() => {
    "Url_viewBody": urlViewBody == null ? null : urlViewBody,
    "responseCode": responseCode == null ? null : responseCode,
    "object": object == null ? null : object,
    "message": message == null ? null : message,
    "refreshedToken": refreshedToken,
    "url_viewBody": baseResponseUrlViewBody == null ? null : baseResponseUrlViewBody,
    "htmlContent": htmlContent == null ? null : htmlContent,
    "securityType": securityType,
  };
}
