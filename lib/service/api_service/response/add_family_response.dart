class AddFamilyResponse {
  final int? id;
  final int? userId;
  final int? familyMemberId;
  final String? phoneNumber;
  final String? message;
  final String? timestamp;
  final String? status;
  final dynamic responseMessage;
  final dynamic tokenFcm;
  final dynamic longitude;
  final dynamic latitude;
  final bool? isFire;

  AddFamilyResponse({
    this.id,
    this.userId,
    this.familyMemberId,
    this.phoneNumber,
    this.message,
    this.timestamp,
    this.status,
    this.responseMessage,
    this.tokenFcm,
    this.longitude,
    this.latitude,
    this.isFire,
  });

  factory AddFamilyResponse.fromJson(Map<String, dynamic> json) {
    return AddFamilyResponse(
      id: json["id"],
      userId: json["user_id"],
      familyMemberId: json["family_member_id"],
      phoneNumber: json["phone_number"],
      message: json["message"],
      timestamp: json["timestamp"],
      status: json["status"],
      responseMessage: json["response_message"],
      tokenFcm: json["token_fcm"],
      longitude: json["longitude"],
      latitude: json["latitude"],
      isFire: json["is_fire"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "family_member_id": familyMemberId,
        "phone_number": phoneNumber,
        "message": message,
        "timestamp": timestamp,
        "status": status,
        "response_message": responseMessage,
        "token_fcm": tokenFcm,
        "longitude": longitude,
        "latitude": latitude,
        "is_fire": isFire,
  };

  @override
  String toString() {
    return  'AddFamilyResponse{id: $id, user_id: $userId, family_member_id: $familyMemberId, phone_number: $phoneNumber, message: $message, timestamp: $timestamp, status: $status, response_message: $responseMessage, token_fcm: $tokenFcm, longitude: $longitude, latitude: $latitude, is_fire: $isFire}';
  }
}
