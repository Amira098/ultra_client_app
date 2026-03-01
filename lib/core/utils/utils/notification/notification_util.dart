// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:mobile_app/constants/app_constants.dart';
// import 'package:mobile_app/data/sharedPreferences.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:provider/provider.dart';
// import '../../myApp.dart';
// import '../../providers/common_provider.dart';
//
// class NotificationUtil {
//   /// Notification setting
//   static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
//   static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   static NotificationDetails? notificationDetails;
//
//   static void handleNotification() {
//     setupLocalNotificationSettings();
//     setupRemoteNotificationSettings();
//   }
//
//   static void setupRemoteNotificationSettings() async {
//     /// generate firebase token firebase
//     firebaseMessaging.getToken().then((token) {
//       print("Firebase Token:-   $token");
//       saveString(FIREBASE_TOKEN, token!);
// /*      Provider.of<CommonProvider>(
//               MyApp.navigatorKey.currentState!.overlay!.context,
//               listen: false)
//           .updateFcmToken(fcmToken: token);*/
//     });
//
//     /// ios configuration
//     if (Platform.isIOS) {
//       NotificationSettings settings = await firebaseMessaging.requestPermission(
//         alert: true,
//         announcement: false,
//         badge: true,
//         carPlay: false,
//         criticalAlert: false,
//         provisional: false,
//         sound: true,
//       );
//       print('User granted permission: ${settings.authorizationStatus}');
//       if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//         print('User granted permission');
//       } else if (settings.authorizationStatus ==
//           AuthorizationStatus.provisional) {
//         print('User granted provisional permission');
//       } else {
//         print('User declined or has not accepted permission');
//       }
//     }
//
//     /// while app is open
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print(' onMessage Got a message whilst in the foreground!');
//       print(' data: ${message.data}');
//       print('notification  is : ${message.notification}');
//
//       if (message.notification != null) {
//         _showLocalNotification(
//           message: message,
//         );
//       }
//     });
//
//     /// while app is in background
//     FirebaseMessaging.onBackgroundMessage((message) {
//       return setupNotificationOnBackground();
//     });
//     setupNotificationOnBackground();
//   }
//
//   static void setupLocalNotificationSettings() {
//     /// local notifications handle
//     var initializationSettingsIOS = new IOSInitializationSettings(
//       defaultPresentAlert: true,
//       defaultPresentBadge: false,
//       defaultPresentSound: true,
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );
//     var initializationSettingsAndroid = new AndroidInitializationSettings(
//       '@mipmap/launcher_icon',
//     );
//     var initializationSettings = new InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );
//
//     var platform = initializationSettings;
//     flutterLocalNotificationsPlugin.initialize(platform,
//         onSelectNotification: _openProductDetails);
//
//     var android = new AndroidNotificationDetails(
//       'CHANNEL ID',
//       "CHANNEL NAME",
//       channelDescription: "channelDescription",
//     );
//     var iOS = new IOSNotificationDetails();
//     notificationDetails = new NotificationDetails(android: android, iOS: iOS);
//   }
//
//   static Future<void> setupNotificationOnBackground() async {
//     RemoteMessage? initialMessage =
//         await FirebaseMessaging.instance.getInitialMessage();
//
//     if (initialMessage != null) {
//       _handleClickOnRemoteNotification(initialMessage);
//     }
//
//     FirebaseMessaging.onMessageOpenedApp
//         .listen(_handleClickOnRemoteNotification);
//   }
//
//   static void _handleClickOnRemoteNotification(RemoteMessage message) {
//     Future.delayed(Duration(seconds: 1), () {
//       _openProductDetails('${message.data['id']} ${message.data['type']}');
//     });
//   }
//
//   static _showLocalNotification({
//     RemoteMessage? message,
//   }) async {
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       message!.notification!.title,
//       message.notification!.body,
//       notificationDetails,
//       payload: '${message.data['id']} ${message.data['type']}',
//     );
//   }
//
//   static void _openProductDetails(String? payload) async {
// /*    print("PAYLOAD IS $payload");
//     if (payload != null) {
//       List<String> payloadData = payload.split(" ");
//       if(payloadData.length == 2) {
//         if (payloadData[1] == ItemType.wholesale) {
//          *//* Navigator.push(
//             MyApp.navigatorKey.currentState!.overlay!.context,
//             MaterialPageRoute(builder: (context) => OfferDetailsScreen(offerID: int.parse(payloadData[0]),)),
//           );*//*
//         }
//         else if (payloadData[1] == ItemType.bundle) {
//         *//*  Navigator.push( MyApp.navigatorKey.currentState!.overlay!.context, MaterialPageRoute(builder:
//               (BuildContext context ){
//             return BagsDetailsScreen(
//                 OfferID: int.parse(payloadData[0])
//             );
//           }
//           )
//           );*//*
//         }
//         else if (payloadData[1] == ItemType.product) {
//           pushNewScreen( ProductDetailsScreen(productId: int.parse(payloadData[0],),));
//         }
//       }
//     }*/
//   }
//
//
// }
