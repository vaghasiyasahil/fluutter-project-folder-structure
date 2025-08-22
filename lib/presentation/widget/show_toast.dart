import '../../export.dart';

void showToast(String msg, [Color? color]) {
  Get.showSnackbar(GetSnackBar(
    animationDuration: const Duration(seconds: 1),
    borderRadius: 8,
    padding: const EdgeInsets.all(15),
    margin: const EdgeInsets.all(15),
    duration: const Duration(milliseconds: 2000),
    messageText: Text(msg,
        style:
        GoogleFonts.poppins(fontSize: 14, color: AppColors.kWhite)),
    backgroundColor: color ?? AppColors.kGrey,
  ));
}
