import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';
import '../../export.dart';


class Repository {
  static Future<Map<String, dynamic>?> login({required String phone, required String password}) async {
    try {
      return await DioApiHelper(isTokeNeeded: false).post(url: Apis.login, body: {"idcode": phone.trim(), "password": password.trim(), "fcm_token":HiveHelper.getFcmToken});
    } catch (e) {
      return null;
    }
  }
  static Future<Map<String, dynamic>?> signup({
    required String name,
    required String email,
    required String number,
    required String gender,
    required String age,
    required String dateOfBirth,
    required String state,
    required String district,
    required String aadharCardNumber,
    required String panCardNumber,
    required String address,
    required String storeName,
    required String businessAddress,
    required String gstNumber,
    required String accountHolderName,
    required String accountNumber,
    required String ifscCode,
    required String accountType,
    // required String drugLicense,
    required String drugLicenseStatus,
    required File? panCardPhoto,
    required File? aadharCardPhoto,
    required File? profilePhoto,
    required File? drugLicense,
  }) async {
    try {

      final formData = dio.FormData.fromMap({
        "fullName": name.trim(),
        "email": email.trim(),
        "mobileNumber": number.trim(),
        "gender": gender.trim(),
        "age": age.trim(),
        "dateOfBirth": dateOfBirth.trim(),
        "state": state.trim(),
        "district": district.trim(),
        "address": address.trim(),
        "aadharCardNumber": aadharCardNumber.trim(),
        "panCardNumber": panCardNumber.trim(),
        "storeName": storeName.trim(),
        "businessAddress": businessAddress.trim(),
        "gstin": gstNumber.trim(),
        "accountHolderName": accountHolderName.trim(),
        "accountNumber": accountNumber.trim(),
        "ifscCode": ifscCode.trim(),
        "accountType": accountType.trim(),
        // "drugLicense": drugLicense,
        "drugLicenseStatus": drugLicenseStatus.trim(),
        "fcm_token": HiveHelper.getFcmToken,

        'panCardPhoto':
            panCardPhoto != null
                ? kIsWeb
                    ? dio.MultipartFile.fromBytes(await XFile(panCardPhoto.path).readAsBytes(), filename: panCardPhoto.path.split('/').last, contentType: MediaType('image', 'jpeg'))
                    : await dio.MultipartFile.fromFile(panCardPhoto.path, filename: panCardPhoto.path.split('/').last, contentType: MediaType('image', 'jpeg'))
                : null,
        'aadharCardPhoto':
            aadharCardPhoto != null
                ? kIsWeb
                    ? dio.MultipartFile.fromBytes(await XFile(aadharCardPhoto.path).readAsBytes(), filename: aadharCardPhoto.path.split('/').last, contentType: MediaType('image', 'jpeg'))
                    : await dio.MultipartFile.fromFile(aadharCardPhoto.path, filename: aadharCardPhoto.path.split('/').last, contentType: MediaType('image', 'jpeg'))
                : null,
        'drugLicense':
        drugLicense != null
                ? kIsWeb
                    ? dio.MultipartFile.fromBytes(await XFile(drugLicense.path).readAsBytes(), filename: drugLicense.path.split('/').last, contentType: MediaType('image', 'jpeg'))
                    : await dio.MultipartFile.fromFile(drugLicense.path, filename: drugLicense.path.split('/').last, contentType: MediaType('image', 'jpeg'))
                : null,
        'profilePicture':
            profilePhoto != null
                ? kIsWeb
                    ? dio.MultipartFile.fromBytes(await XFile(profilePhoto.path).readAsBytes(), filename: profilePhoto.path.split('/').last, contentType: MediaType('image', 'jpeg'))
                    : await dio.MultipartFile.fromFile(profilePhoto.path, filename: profilePhoto.path.split('/').last, contentType: MediaType('image', 'jpeg'))
                : null,
      });
      final response = await DioApiHelper(isTokeNeeded: false).multipartPost(
        url: Apis.login,
        data: formData,
        // method: "POST",
      );
      return response;
    } catch (e) {
      debugPrint('Signup error: $e');
      return null;
    }
  }

  // static Future<Map<String, dynamic>?> signup({
  //   required String name,
  //   required String email,
  //   required String number,
  //   required String password,
  //   required String gender,
  //   required String age,
  //   required String dateOfBirth,
  //   required String state,
  //   required String district,
  //   required String aadharCardNumber,
  //   required String panCardNumber,
  //   required String address,
  //   required String storeName,
  //   required String businessAddress,
  //   required String gstNumber,
  //   required String accountHolderName,
  //   required String accountNumber,
  //   required String ifscCode,
  //   required String accountType,
  //   required String drugLicense,
  //   required String pharmacyLicense,
  //   required String drugLicenseStatus,
  //   required String panCardPhoto,
  //   required String aadharCardPhoto,
  //   required String profilePhoto,
  // }) async {
  //   try{
  //     return await DioApiHelper(isTokeNeeded: false).post(
  //       url: Apis.signup,
  //       body: {
  //         "fullName": name,
  //         "email": email,
  //         "mobileNumber": number,
  //         "password": password,
  //         "gender": gender,
  //         "age": age,
  //         "dateOfBirth": dateOfBirth,
  //         "state": state,
  //         "district": district,
  //         "address": address,
  //         "aadharCardNumber": aadharCardNumber,
  //         "panCardNumber": panCardNumber,
  //         "storeName": storeName,
  //         "businessAddress": businessAddress,
  //         "gstin": gstNumber,
  //         "accountHolderName": accountHolderName,
  //         "accountNumber": accountNumber,
  //         "ifscCode": ifscCode,
  //         "accountType": accountType,
  //         "pharmacyLicense": pharmacyLicense,
  //         "drugLicense": drugLicense,
  //         "drugLicenseStatus": drugLicenseStatus,
  //         "panCardPhoto": panCardPhoto,
  //         "aadharCardPhoto": aadharCardPhoto,
  //       },
  //     );
  //   }catch(e){
  //     return null;
  //   }
  // }



  static Future<Map<String, dynamic>?> getProfile() async {
    try {
      return await DioApiHelper(isTokeNeeded: true).get(url: Apis.login);
    } catch (e) {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> removeAddress({required int addressId, required bool permanentDelete}) async {
    Map<String, dynamic>? data = await DioApiHelper(isTokeNeeded: true).delete(url: "${Apis.login}$addressId?permanent=$permanentDelete");
    return data;
  }

}
