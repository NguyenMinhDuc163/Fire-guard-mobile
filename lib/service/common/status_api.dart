

class StatusApi {

  /*sv local*/
static const  String BASE_API_URL = "/"; // test local

static const int TIME_OUT = 20000;
// Error

  static const String SERVE_RESPONSE_TEXT_ERROR500 = '500';

//* TODO module login
  static const STATUS_LOGIN_AUTHENTICATION_AUTH00 = 'AUTH00';
  static const STATUS_LOGIN_AUTHENTICATION_AUTH06 =
      'AUTH06'; //tai khoản chưa kích hoạt
  static const STATUS_LOGIN_AUTHENTICATION_AUTH07 =
      'AUTH07'; //tài khoản bị khóa do đăng nhập sai
  static const STATUS_LOGIN_AUTHENTICATION_AUTH08 =
      'AUTH08'; //tài khoản đăng nhập lần đầu
  static const STATUS_UPDATE_INFO_SUCCESS = 'CI00';

  //OTP
  static const SENT_OTP_UNCORECT = "OTP02"; //GUI OTP KHONG DUNG
  static const SENT_OTP_END_TIME = "OTP03"; //GUI OTP HET THOI GIAN;
  //Mật khẩu
  static const CHANGE_PASS_ERROR = "CPWD99"; //Loi doi mat khau

  static const CHANGE_PASS_SUCCESS = "CPWD00";
  static const WRONG_OLD_PASS = "CPWD04";

  static const RESET_PASSWORD_SUCCESS = "FP00";

  static const INVOICE_REPORT_SUCCESS = "TRACUUHD00";
  static const MONEY_KIND_SUCCESS = "GDM002";
  static const NOTIFICATION_SUCCESS = "PRL00";
  static const USER_MOBILE_INFO_SUCCESS = "USER_SUCC";
  static const REGISTER_FINGERPRINT_SUCCESS = "REGISTER_FINGER_SUCC";
  static const VERIFY_INVOICE_SUCCESS = "CTR200";
}


