import 'dart:ui';
import '../../export.dart';


class Loader {
  static bool isLoader = false;

  Loader.showLoader() {
    if (isLoader == false) {
      isLoader = true;
      Get.dialog(
          PopScope(
            canPop: false,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.kWhite),
              ),
            ),
          ),
          barrierDismissible: false);
    }
  }

  Loader.closeLoader() {
    if (isLoader == true) {
      Get.back();
      isLoader = false;
    }
  }
}
