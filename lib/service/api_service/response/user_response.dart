
class UserResponse {
  UserResponse({
    this.userId,
    this.fullName,
    this.token,
    this.responseCode,
    this.message,
    this.lastLoginTime,
    this.serialNo,
    this.rulePass,
    this.ruleMessage,
    this.versionAppMobile,
    this.securityType,
    this.isNoti,
    this.isFingerLogin,
    this.isFingerOtp,
    this.corpId,
    this.tin,
    this.email,
    this.tel,
    this.addr,
    this.fax,
    this.roleId,
    this.nick,
    this.decimalFmt,
  });

  final String? userId;
  final String? fullName;
  final String? token;
  final String? responseCode;
  final String? message;
  final String? lastLoginTime;
  final String? serialNo;
  final String? rulePass;
  final String? ruleMessage;
  final String? versionAppMobile;
  final String? securityType;
  final String? isNoti;
  final String? isFingerLogin;
  final String? isFingerOtp;
  final String? corpId;
  final String? tin;
  final String? email;
  final String? tel;
  final String? addr;
  final String? fax;
  final int? roleId;
  final String? nick;
  final String? decimalFmt;

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
    userId: json["userId"] == null ? null : json["userId"],
    fullName: json["fullName"] == null ? null : json["fullName"],
    token: json["token"] == null ? null : json["token"],
    responseCode: json["responseCode"] == null ? null : json["responseCode"],
    message: json["message"] == null ? null : json["message"],
    lastLoginTime: json["lastLoginTime"] == null ? null : json["lastLoginTime"],
    serialNo: json["serialNo"] == null ? null : json["serialNo"],
    rulePass: json["rulePass"] == null ? null : json["rulePass"],
    ruleMessage: json["ruleMessage"] == null ? null : json["ruleMessage"],
    versionAppMobile: json["versionAppMobile"] == null ? null : json["versionAppMobile"],
    securityType: json["securityType"] == null ? null : json["securityType"],
    isNoti: json["is_Noti"],
    isFingerLogin: json["isFingerLogin"],
    isFingerOtp: json["isFingerOtp"],
    corpId: json["corpId"] == null ? null : json["corpId"],
    tin: json["tin"] == null ? null : json["tin"],
    email: json["email"] == null ? null : json["email"],
    tel: json["tel"] == null ? null : json["tel"],
    addr: json["addr"] == null ? null : json["addr"],
    fax: json["fax"],
    roleId: json["roleId"] == null ? null : json["roleId"],
    nick: json["nick"] == null ? null : json["nick"],
    decimalFmt: json["decimalFmt"] == null ? null : json["decimalFmt"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId == null ? null : userId,
    "fullName": fullName == null ? null : fullName,
    "token": token == null ? null : token,
    "responseCode": responseCode == null ? null : responseCode,
    "message": message == null ? null : message,
    "lastLoginTime": lastLoginTime == null ? null : lastLoginTime,
    "serialNo": serialNo == null ? null : serialNo,
    "rulePass": rulePass == null ? null : rulePass,
    "ruleMessage": ruleMessage == null ? null : ruleMessage,
    "versionAppMobile": versionAppMobile == null ? null : versionAppMobile,
    "securityType": securityType == null ? null : securityType,
    "is_Noti": isNoti,
    "isFingerLogin": isFingerLogin,
    "isFingerOtp": isFingerOtp,
    "corpId": corpId == null ? null : corpId,
    "tin": tin == null ? null : tin,
    "email": email == null ? null : email,
    "tel": tel == null ? null : tel,
    "addr": addr == null ? null : addr,
    "fax": fax,
    "roleId": roleId == null ? null : roleId,
    "nick": nick == null ? null : nick,
    "decimalFmt": decimalFmt == null ? null : decimalFmt,
  };
}


