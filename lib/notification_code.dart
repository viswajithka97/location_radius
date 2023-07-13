import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  importance: Importance.high,
  playSound: true,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

notificationMainMethod() async {
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });

  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(alert: true, badge: true, sound: true);

  // ignore: unused_local_variable
  final List<ActiveNotification>? activeNotifications =
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.getActiveNotifications();
  // log('activeNotifications $activeNotifications');

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  // IOSInitializationSettings initializationSettingsIOS =
  //     const IOSInitializationSettings();
  final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
    defaultPresentAlert: true,
    defaultPresentSound: true,
    notificationCategories: [
      DarwinNotificationCategory(
        'category',
        options: {
          DarwinNotificationCategoryOption.allowAnnouncement,
        },
        actions: [
          DarwinNotificationAction.plain(
            'snoozeAction',
            'snooze',
          ),
          DarwinNotificationAction.plain(
            'confirmAction',
            'confirm',
            options: {
              DarwinNotificationActionOption.authenticationRequired,
            },
          ),
        ],
      ),
    ],
  );
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      // onDidReceiveBackgroundNotificationResponse: notificationData,
      onDidReceiveNotificationResponse: (NotificationResponse value) async {});
}

// void onMessageOpenedAppFn(RemoteMessage message) {
//   log("onMessageOpenedAppFn");
//   commonControllert
//       .notificatinNavigations(
//     message.data['type'].toString(),
//   )
//       .then((value) {
//     GetStorage('notification_type').write('notification_type', "");
//   });
// }

// void getMessages(RemoteMessage message) async {
//   print('get message fun called');
//   if (kDebugMode) {
//     print('Got a message whilst in the foreground!');
//     print('Message data:: ${message.data}');
//     print('Message data:: ${message.messageType}');
//     print('Message category:: ${message.category}');
//     print('Message collapseKey:: ${message.collapseKey}');
//     print('Message contentAvailable:: ${message.contentAvailable}');
//     print('Message from:: ${message.from}');
//     print('Message messageType:: ${message.messageType}');
//     print('Message mutableContent:: ${message.mutableContent}');
//   }
//   triggerNotification(message);
// }

// @pragma('vm:entry-point')
// notificationData(NotificationResponse value) async {
//   commonControllert.notificatinNavigations(
//     value.payload.toString(),
//   );
// }

// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   triggerNotification(message);
//   print('A bg message just showed up :  ${message.messageId}');
//   print('Got a message whilst in the Background!');
//   print('Message data:: ${message.data}');
//   print('Message category:: ${message.category}');
//   print('Message collapseKey:: ${message.collapseKey}');
//   print('Message contentAvailable:: ${message.contentAvailable}');
//   print('Message from:: ${message.from}');
//   print('Message messageType:: ${message.messageType}');
//   print('Message mutableContent:: ${message.mutableContent}');
// }

// void triggerNotification(RemoteMessage message) {
//   RemoteNotification? notification = message.notification;
//   AndroidNotification? android = message.notification?.android;

//   print('notification:: $notification');

//   print('android:: ${android ?? "Hello"}');

//   if (android != null && notification != null) {
//     log('android:: ${notification.android}');
//     log('apple:: ${notification.apple}');
//     log('body:: ${notification.body}');
//     log('bodyLocArgs:: ${notification.bodyLocArgs}');
//     log('bodyLocKey:: ${notification.bodyLocKey}');
//     log('title:: ${notification.title}');
//     log('titleLocArgs:: ${notification.titleLocArgs}');
//     log('titleLocKey:: ${notification.titleLocKey}');
//     log("firebase notification");

//     flutterLocalNotificationsPlugin.show(
//       message.messageId.hashCode,
//       notification.title,
//       notification.body,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           channel.id,
//           channel.name,
//           playSound: true,
//           icon: '@mipmap/ic_launcher',
//         ),
//         iOS: const DarwinNotificationDetails(),
//       ),
//       payload: message.data['type'].toString(),
//     );
//   } else {
//     log("custom notification");

//     flutterLocalNotificationsPlugin.show(
//       message.messageId.hashCode,
//       message.data['title'],
//       message.data['body'],
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           channel.id,
//           channel.name,
//           playSound: true,
//           icon: '@mipmap/ic_launcher',
//         ),
//         iOS: const DarwinNotificationDetails(),
//       ),
//       payload: message.data['type'].toString(),
//     );
//     return;
//   }
// }
