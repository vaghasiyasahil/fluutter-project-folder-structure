import '../../../export.dart';

class InternetScreen extends StatelessWidget {
  InternetScreen({super.key});

  final controller = Get.put(InternetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Option 1: Use animated illustration or image
              // Image.asset('assets/images/no_internet.png', height: 180),

              // Option 2: Styled Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.kPrimary.withValues(alpha: 0.1),
                ),
                child: const Icon(Icons.wifi_off, size: 80, color: AppColors.kPrimary),
              ).paddingOnly(bottom: 60),


              Text(
                "No Internet Connection",
                style: AppStyle.k16600Primary,
              ),

              Text(
                "It seems you're offline.\nPlease check your internet and try again.",
                style: AppStyle.k16600Primary,
                textAlign: TextAlign.center,
              ).paddingOnly(top: 20,bottom: 60),




              GestureDetector(
                onTap: () async {
                  final connectivity = await Connectivity().checkConnectivity();
                  if (connectivity != ConnectivityResult.none) {
                    Get.back();
                  }
                },
                child: Container(
                  width: 150,
                  padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.kPrimary,
                        AppColors.kPrimary,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.kPrimary.withValues(alpha: 0.3),
                        offset: const Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.refresh, color: Colors.white),
                      const SizedBox(width: 10),
                      Text(
                        "Retry",
                        style: AppStyle.k16600Primary,
                      ),
                    ],
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
