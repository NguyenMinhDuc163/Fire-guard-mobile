class UserModel {
  String? id;
  String? userName;
  String? phoneNum;
  String? email;
  String? password;

  UserModel({
    this.id,
    this.userName,
    this.phoneNum,
    this.email,
    this.password,
  });

  @override
  String toString() {
    return 'UserModel{id: $id, userName: $userName, phoneNum: $phoneNum, email: $email, password: $password}';
  }

  factory UserModel.fromMap(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      userName: data['userName'],
      phoneNum: data['phoneNum'],
      email: data['email'],
      password: data['password'],
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      userName: json['userName'],
      phoneNum: json['phoneNum'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userName'] = userName;
    data['phoneNum'] = phoneNum;
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}