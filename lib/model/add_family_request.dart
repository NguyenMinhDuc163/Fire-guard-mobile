class AddFamilyRequest {
  final int userId;
  final int familyMemberId;

  AddFamilyRequest({
    required this.userId,
    required this.familyMemberId,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'familyMemberId': familyMemberId,
    };
  }
}
