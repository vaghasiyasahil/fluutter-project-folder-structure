import 'package:dio/dio.dart' as diox;
import '../../export.dart';

final logger = Logger();

class DioApiHelper {
  late Map<String, dynamic> header;
  final diox.Dio dio = diox.Dio();

  DioApiHelper({bool? isTokeNeeded}) {
    header =
        isTokeNeeded == false
            ? {'Content-Type': 'application/json', 'Accept': 'application/json'}
            : {'Authorization': 'Bearer ${HiveHelper.getToken}', 'Content-Type': 'application/json', 'Accept': 'application/json'};
  }

  Future<dynamic> post({required String url, required Map<String, dynamic> body}) async {
    try {
      diox.Response response = await dio.post(url, options: diox.Options(headers: header), data: body);
      Get.log("StatusCode : ${response.statusCode} \nApi : ${response.requestOptions.uri} \nBody : ${response.requestOptions.data} \nResponse : ${jsonEncode(response.data)}");
      Loader.closeLoader();
      return response.data;
    } on diox.DioException catch (e) {
      Loader.closeLoader();
      Get.log("StatusCode : ${e.response?.statusCode} \nApi : ${e.requestOptions.uri} \nBody : ${e.requestOptions.data} \nResponse : ${e.response?.data}");
      if (e.response?.data['message'] != null) {
        if (e.response?.statusCode == 400 || e.response?.statusCode == 403 || e.response?.statusCode == 404) {
          showToast(e.response?.data['message'].toString() ?? 'Something went to wrong', AppColors.kRed);
        } else if (e.response?.statusCode == 401) {
        } else {
          showToast('Something went to wrong');
        }
      } else {
        Get.log(e.toString());
      }
      rethrow;
    }
  }

  Future<dynamic> put({required String url, required Map<String, dynamic> body}) async {
    try {
      diox.Response response = await dio.put(url, options: diox.Options(headers: header), data: body);
      Get.log("StatusCode : ${response.statusCode} \nApi : ${response.requestOptions.uri} \nBody : ${response.requestOptions.data} \nResponse : ${jsonEncode(response.data)}");
      if (response.data["success"] == true) {
        Get.log("StatusCode : ${response.statusCode} \nApi : ${response.requestOptions.uri} \nBody : ${response.requestOptions.data} \nResponse : ${jsonEncode(response.data)}");
        Loader.closeLoader();
        return response.data;
      } else {
        Loader.closeLoader();
        Get.log("StatusCode : ${response.statusCode} \nApi : ${response.requestOptions.uri} \nBody : ${response.requestOptions.data} \nResponse : ${response.data}");
        if (response.data['message'] != null) {
          showToast(response.data['message'].toString());
        } else {
          Get.log(response.data);
        }
      }
    } on diox.DioException catch (e) {
      Loader.closeLoader();
      Get.log("StatusCode : ${e.response?.statusCode} \nApi : ${e.requestOptions.uri} \nBody : ${e.requestOptions.data} \nResponse : ${e.response?.data}");
      if (e.response?.data['message'] != null) {
        if (e.response?.statusCode == 400 || e.response?.statusCode == 403) {
          showToast(e.response?.data['message'].toString() ?? 'Something went to wrong');
        } else if (e.response?.statusCode == 401) {
          HiveHelper.clearHive();
          // Get.offAllNamed(Routes.getStartedScreen);
        } else {
          showToast('Something went to wrong');
        }
      } else {
        logger.e(e);
      }
      rethrow;
    }
    return null;
  }

  // Future<dynamic> delete({required String url, Map<String, dynamic>? body}) async {
  //   try {
  //     diox.Response response = await dio.delete(url, options: diox.Options(headers: header), data: body);
  //     Get.log("StatusCode : ${response.statusCode} \nApi : ${response.requestOptions.uri} \nBody : ${response.requestOptions.data} \nResponse : ${jsonEncode(response.data)}");
  //     if (response.data["success"] == true) {
  //       Get.log("StatusCode : ${response.statusCode} \nApi : ${response.requestOptions.uri} \nBody : ${response.requestOptions.data} \nResponse : ${jsonEncode(response.data)}");
  //       Loader.closeLoader();
  //       return response.data;
  //     } else {
  //       Loader.closeLoader();
  //       logger.e("StatusCode : ${response.statusCode} \nApi : ${response.requestOptions.uri} \nBody : ${response.requestOptions.data} \nResponse : ${response.data}");
  //       if (response.data['message'] != null) {
  //         showToast(response.data['message'].toString());
  //       } else {
  //         logger.e(response.data);
  //       }
  //     }
  //   } on diox.DioException catch (e) {
  //     Loader.closeLoader();
  //     logger.e("StatusCode : ${e.response?.statusCode} \nApi : ${e.requestOptions.uri} \nBody : ${e.requestOptions.data} \nResponse : ${e.response?.data}");
  //     if (e.response?.data['message'] != null) {
  //       if (e.response?.statusCode == 400) {
  //         showToast(e.response?.data['message'].toString() ?? 'Something went to wrong');
  //       } else if (e.response?.statusCode == 401) {
  //         HiveHelper.clearHive();
  //         // Get.offAllNamed(Routes.getStartedScreen);
  //       } else {
  //         showToast('Something went to wrong');
  //       }
  //     } else {
  //       logger.e(e);
  //     }
  //     rethrow;
  //   }
  //   return null;
  // }

  Future<dynamic> delete({required String url, Map<String, dynamic>? body}) async {
    try {
      diox.Response response = await dio.delete(url, options: diox.Options(headers: header), data: body);

      Get.log("StatusCode : ${response.statusCode} \nApi : ${response.requestOptions.uri} \nBody : ${response.requestOptions.data} \nResponse : ${jsonEncode(response.data)}");

      Loader.closeLoader();
      return response.data;
    } on diox.DioException catch (e) {
      Loader.closeLoader();
      logger.e("StatusCode : ${e.response?.statusCode} \nApi : ${e.requestOptions.uri} \nBody : ${e.requestOptions.data} \nResponse : ${e.response?.data}");
      if (e.response?.data['message'] != null) {
        if (e.response?.statusCode == 400) {
          showToast(e.response?.data['message'].toString() ?? 'Something went wrong');
        } else if (e.response?.statusCode == 401) {
          HiveHelper.clearHive();
          // Get.offAllNamed(Routes.getStartedScreen);
        } else {
          showToast('Something went wrong');
        }
      } else {
        logger.e(e);
      }
      rethrow;
    }
  }

  Future<dynamic> get({required String url, bool? showErrorToast = true, Map<String, dynamic>? body}) async {
    try {
      diox.Response response = await dio.get(url, data: body, options: diox.Options(headers: header));
      Get.log(
        "StatusCode : ${response.statusCode} \nApi : ${response.requestOptions.uri} \nBody : ${response.requestOptions.data} \nResponse : ${jsonEncode(response.data)} \nHeader : ${jsonEncode(response.requestOptions.headers)}",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Loader.closeLoader();
        return response.data;
      } else {
        if (showErrorToast == true) {
          showToast(response.data['message']);
        }
        logger.e(response.data);
      }
    } on diox.DioException catch (e) {
      Loader.closeLoader();
      Get.log(
        "StatusCode : ${e.response?.statusCode} \nApi : ${e.response?.requestOptions.uri} \nBody : ${e.response?.requestOptions.data} \nResponse : ${jsonEncode(e.response?.data)} \nHeader : ${jsonEncode(e.response?.requestOptions.headers)}",
      );

      if (e.response?.data['message'] != null && e.response?.data['message'].runtimeType == String) {
        if (e.response?.statusCode == 400 || e.response?.statusCode == 403) {
          if (showErrorToast == true) {
            showToast(e.response?.data['message'].toString() ?? 'Something went to wrong');
          }
        } else if (e.response?.statusCode == 401) {
          HiveHelper.clearHive();
          // Get.offAllNamed(Routes.getStartedScreen);
        } else {
          if (showErrorToast == true) {
            showToast('Something went to wrong');
          }
        }
      } else {
        logger.e(e);
      }
      rethrow;
    }
    return null;
  }

  Future<Map<String, dynamic>?> multipartPost({
    required diox.FormData data,
    required String url,
    String? method,
  }) async {
    try {
      Get.log("Parameter ${data.fields}");

      diox.Response response = await dio.request(
        url,
        options: diox.Options(
          method: method ?? 'POST',
          headers: {
            'Authorization': 'Bearer ${HiveHelper.getToken}',
            'Content-Type': 'multipart/form-data',
          },
        ),
        data: data,
      );

      Get.log(
        "StatusCode : ${response.statusCode} \n"
            "Api : ${response.requestOptions.uri} \n"
            "Body : ${response.requestOptions.data} \n"
            "Response : ${jsonEncode(response.data)} \n"
            "Header : ${jsonEncode(response.requestOptions.headers)}",
      );

      Loader.closeLoader();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        showToast('Something went wrong', AppColors.kRed);
        return null;
      }

    } on diox.DioException catch (e) {
      Loader.closeLoader();

      Get.log(
        "StatusCode : ${e.response?.statusCode} \n"
            "Api : ${e.response?.requestOptions.uri} \n"
            "Body : ${e.response?.requestOptions.data} \n"
            "Response : ${jsonEncode(e.response?.data)} \n"
            "Header : ${jsonEncode(e.response?.requestOptions.headers)}",
      );

      if (e.response?.data['message'] is String) {
        if (e.response?.statusCode == 400 || e.response?.statusCode == 403) {
          showToast(e.response?.data['message'], AppColors.kRed);
        } else if (e.response?.statusCode == 401) {
          HiveHelper.clearHive();
          // Get.offAllNamed(Routes.getStartedScreen);
        } else {
          showToast('Something went wrong', AppColors.kRed);
        }
      } else {
        logger.e(e);
      }

      rethrow;
    } catch (e) {
      Loader.closeLoader();
      Get.log("Unexpected error in multipartPost: $e");
      showToast('Something went wrong', AppColors.kRed);
      rethrow;
    }
  }
}