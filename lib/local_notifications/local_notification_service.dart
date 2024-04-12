import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../controllers/chat_controller.dart';
import '../models/chat_message_model.dart';

class LocalNotificationService {

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static late ChatMessageModel chatMessageModel;

  static void notificationTapBackground(NotificationResponse notificationResponse) {

    Get.find<ChatPageController>().setPendingMessageNumber(chatMessageModel.receiverId!, chatMessageModel.senderId!);

  }

  Future<void> init() async {
    // Initialize native android notification
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // Initialize native Ios Notifications
    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  void showNotificationAndroid(ChatMessageModel chatMessageModel) async {

    LocalNotificationService.chatMessageModel = chatMessageModel;

    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('channel_id', 'Channel Name',
        channelDescription: 'Channel Description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');

    int notification_id = 1;
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin
        .show(notification_id, chatMessageModel.senderEmail, chatMessageModel.message, notificationDetails, payload: 'Not present');
  }


  void showNotificationIos(ChatMessageModel chatMessageModel) async {

    LocalNotificationService.chatMessageModel = chatMessageModel;

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
    DarwinNotificationDetails(
        presentAlert: true,  // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
        presentBadge: true,  // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
        presentSound: true,  // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)// Specifics the file path to play (only from iOS 10 onwards)
        subtitle: "App Notification", //Secondary description  (only from iOS 10 onwards)
    );

    int notification_id = 1;

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin
        .show(notification_id, chatMessageModel.senderEmail, chatMessageModel.message, platformChannelSpecifics, payload: 'Not present');
  }

}