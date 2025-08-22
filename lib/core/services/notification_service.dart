import 'package:dio/dio.dart' as diox;
import '../../export.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationService._privateConstructor();

  static final NotificationService _instance = NotificationService._privateConstructor();

  static NotificationService get instance => _instance;

  Function(RemoteMessage)? onForegroundMessage;

  Future<void> initialize() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    Get.log('firebase :: User granted permission: ${settings.authorizationStatus}');
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('mylogo');

    const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Get.log('firebase :: Received a foreground message: ${message.messageId}');
      _showNotification(message);

      if (onForegroundMessage != null) {
        onForegroundMessage!(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Get.log('firebase :: Notification clicked! Message: ${message.notification?.title}');
      _handleNotificationClick(message);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _showNotification(RemoteMessage message) async {
    String? imgUrl = message.notification?.android?.imageUrl;
    BigPictureStyleInformation? bigPictureStyleInformation;
    if (imgUrl != null) {
      try {
        diox.Dio dio = diox.Dio();
        diox.Response<List<int>> response = await dio.get<List<int>>(
          imgUrl,
          options: diox.Options(responseType: diox.ResponseType.bytes),
        );
        Uint8List imageBytes = Uint8List.fromList(response.data!);
        String base64Image = base64Encode(imageBytes);
        bigPictureStyleInformation = BigPictureStyleInformation(
          ByteArrayAndroidBitmap.fromBase64String(base64Image),
          contentTitle: message.notification?.title,
          summaryText: message.notification?.body,
        );
      } catch (e) {
        Get.log('Error fetching image: $e');
      }
    }

    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: bigPictureStyleInformation,
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: const DarwinNotificationDetails(),
    );

    await _flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
      platformChannelSpecifics,
    );
  }

  Future<void> _handleNotificationClick(RemoteMessage message) async {
    Get.log('firebase :: User tapped on notification: ${message.notification?.title}');
  }

  Future<void> _onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (payload != null) {
      Get.log('firebase :: Notification payload: $payload');
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    Get.log('firebase :: Handling a background message: ${message.messageId}');
  }

  Future<String?> getDeviceToken() async {
    String? token = await _firebaseMessaging.getToken();
    Get.log("Device Token: $token");
    return token;
  }
}
