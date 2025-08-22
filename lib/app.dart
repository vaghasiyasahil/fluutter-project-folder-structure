
import 'export.dart';

class AppName extends StatelessWidget {
  const AppName({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: Pages().pages,
      initialRoute: Routes.splashScreen,
      theme: ThemeData(
        useMaterial3: true,
        splashColor: AppColors.kGrey.withValues(alpha: 0.1),
        highlightColor: AppColors.kGrey,
        hoverColor: AppColors.kGrey,
        unselectedWidgetColor: AppColors.kGrey,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.kGrey),
        textSelectionTheme: const TextSelectionThemeData(selectionHandleColor: AppColors.kGrey),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: MediaQuery.of(context).textScaler.clamp(minScaleFactor: 0.8, maxScaleFactor: 1.6),
        ),
        child: child!,
      ),
      // builder: DevicePreview.appBuilder,
      // locale: DevicePreview.locale(context),
    );
  }
}
