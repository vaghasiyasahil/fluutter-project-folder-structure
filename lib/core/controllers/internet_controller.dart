
import '../../../export.dart';

class InternetController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription _subscription;

  var isOnline = true.obs;

  @override
  void onInit() {
    super.onInit();
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        isOnline.value = false;
        Get.toNamed(Routes.internetScreen);
      } else {
        if (!isOnline.value) {
          Get.back();
        }
        isOnline.value = true;
      }
    });
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
