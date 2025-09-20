import '../../../export.dart';

class Pages {
  List<GetPage<dynamic>> pages = [
    GetPage(name: Routes.splashScreen, page: () => SplashScreen()),
    GetPage(name: Routes.internetScreen, page: () => InternetScreen()),
  ];
}
