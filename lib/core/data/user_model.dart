import '../../export.dart';

class UserModel {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? uid;
  final String? fcmToken;
  final String? deviceId;
  final Timestamp? lastLogin;
  final String? profileUrl;
  final String? loginType;
  final bool? isBlocked;
  final List<int>? purchasedEssays;

  UserModel({
    this.firstName,
    this.lastName,
    this.email,
    this.uid,
    this.fcmToken,
    this.deviceId,
    this.lastLogin,
    this.profileUrl,
    this.purchasedEssays,
    this.loginType,
    this.isBlocked
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : firstName = json['first_name'] as String?,
        lastName = json['last_name'] as String?,
        email = json['email'] as String?,
        uid = json['uid'] as String?,
        fcmToken = json['fcm_token'] as String?,
        deviceId = json['device_id'] as String?,
        lastLogin = json['last_login'] as Timestamp?,
        profileUrl = json['profile_url'] as String?,
        loginType = json['login_type'] as String?,
        isBlocked = json['is_blocked'] as bool? ?? false,
        purchasedEssays = (json['purchased_essays'] as List?)?.map((dynamic e) => e as int).toList();

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'uid': uid,
        'fcm_token': fcmToken,
        'device_id': deviceId,
        'last_login': lastLogin,
        'profile_url': profileUrl,
        'purchased_essays': purchasedEssays,
        'login_type': loginType,
        'is_blocked': isBlocked ?? false
      };
}
