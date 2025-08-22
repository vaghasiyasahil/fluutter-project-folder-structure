import '../../export.dart';

class HiveHelper {
  static late Box hive;
  static const token = "token";
  static const firstTime = "first_time";
  static const fcmToken = "fcmToken";
  static const vendorId = "vendor_id";
  static const otpSessionID = "otp_session_id";
  static const id = "id";
  static const isLogin = "isLogin";
  static const resetPasswordToken = "resetPasswordToken";


  static Future<void> init() async {
    await Hive.initFlutter();
    hive = await Hive.openBox('appName');
  }

  static bool? get getFirstTime => hive.get(firstTime);
  static String? get getToken => hive.get(token);
  static String? get getFcmToken => hive.get(fcmToken);
  static String? get getVendorId => hive.get(vendorId);
  static String? get getOtpSessionId => hive.get(otpSessionID);
  static String? get getId => hive.get(id);
  static String? get getResetPasswordToken => hive.get(resetPasswordToken);
  static bool? get getIsLogin => hive.get(isLogin);


  static Future<void> setFirstTimeState(bool? val) async => await hive.put(firstTime, val);
  static Future<void> setToken(String? val) async => await hive.put(token, val);
  static Future<void> setFcmToken(String? val) async => await hive.put(fcmToken, val);
  static Future<void> setVendorId(String? val) async => await hive.put(vendorId, val);
  static Future<void> setOtpSessionId(String? val) async => await hive.put(otpSessionID, val);
  static Future<void> setId(String? val) async => await hive.put(id, val);
  static Future<void> setIsLogin(bool? val) async => await hive.put(isLogin, val);
  static Future<void> setResetPasswordToken(String? val) async => await hive.put(resetPasswordToken, val);


  static Future<void> clearHive() async => await hive.clear();
}
