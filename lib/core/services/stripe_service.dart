// import 'package:http/http.dart' as http;
// import 'package:flutter_stripe/flutter_stripe.dart';
//
// import '../../export.dart';
//
// class StripeService {
//   static void initStrip() {
//     Stripe.publishableKey = FirebaseConfigHelper.publishableKey;
//     Stripe.merchantIdentifier = 'merchant.com.addmitto.app';
//     Stripe.instance.applySettings();
//   }
//
//   static Future<Map<String, dynamic>> createPaymentIntent(int amount) async {
//     try {
//       Map<String, dynamic> body = {
//         'amount': "${amount * 100}",
//         'currency': "USD",
//       };
//       var response = await http.post(
//         Uri.parse('https://api.stripe.com/v1/payment_intents'),
//         headers: {'Authorization': 'Bearer ${FirebaseConfigHelper.secretKey}', 'Content-Type': 'application/x-www-form-urlencoded'},
//         body: body,
//       );
//
//       return json.decode(response.body);
//     } catch (err) {
//       rethrow;
//     }
//   }
//
//   static Future<void> initPaymentSheet({Map<String, dynamic>? data}) async {
//     try {
//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           customFlow: false,
//           merchantDisplayName: 'Addmitto',
//           appearance: PaymentSheetAppearance(
//               colors: PaymentSheetAppearanceColors(
//             componentBackground: AppColors.kLightGrey,
//             background: AppColors.kWhite,
//             primary: AppColors.kBlue,
//             placeholderText: AppColors.kGrey,
//           )),
//           paymentIntentClientSecret: data?['client_secret'],
//           applePay: const PaymentSheetApplePay(merchantCountryCode: 'US', buttonType: PlatformButtonType.pay),
//           googlePay: const PaymentSheetGooglePay(merchantCountryCode: 'US', testEnv: true, currencyCode: 'USD', buttonType: PlatformButtonType.googlePayMark),
//           style: ThemeMode.light,
//         ),
//       );
//     } on StripeConfigException {
//       rethrow;
//     } catch (e) {
//       showToast('Error: $e');
//       rethrow;
//     }
//   }
//
//   static Future<void> displayPaymentSheet() async {
//     try {
//       await Stripe.instance.presentPaymentSheet().then((value) async {
//         final controller = Get.find<CartController>();
//         await UserService.updatePurchasedList(List.generate(controller.ids.length, (index) => int.parse(controller.ids[index])).toList());
//         LocalStorageHelper.clearCartList();
//         Loader.closeLoader();
//         Get.dialog(
//           PopScope(
//             canPop: false,
//             child: Dialog(
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                 decoration: BoxDecoration(
//                   color: AppColors.kWhite,
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Lottie.asset(
//                       AppImage.paymentSuccess,
//                       repeat: false,
//                       fit: BoxFit.cover,
//                       alignment: Alignment.center,
//                       width: Get.width * 0.5,
//                     ),
//                     Divider(height: 50),
//                     Text('Essay has been successfully purchased!'),
//                     SizedBox(height: 30),
//                     GestureDetector(
//                       onTap: () {
//                         Get.offAllNamed(Routes.homeScreen);
//                       },
//                       child: AnimatedContainer(
//                         duration: Duration(milliseconds: 300),
//                         height: 40,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           color: AppColors.kBlue,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text('Done', style: AppStyle.k16600W),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           barrierDismissible: false,
//         );
//       }).onError((error, stackTrace) => throw Exception(error));
//     } on StripeException {
//       AlertDialog(
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               children: const [
//                 Icon(
//                   Icons.cancel,
//                   color: Colors.red,
//                 ),
//                 Text("Payment Failed"),
//               ],
//             ),
//           ],
//         ),
//       );
//     } catch (e) {
//       Loader.closeLoader();
//       rethrow;
//     }
//   }
//
//   static Future<void> startPayment({required int amount}) async {
//     try {
//       Loader.showLoader();
//       final data = await createPaymentIntent(amount);
//       await initPaymentSheet(data: data);
//       await displayPaymentSheet();
//     } catch (e) {
//       rethrow;
//     }finally {
//       Loader.closeLoader();
//     }
//   }
// }
