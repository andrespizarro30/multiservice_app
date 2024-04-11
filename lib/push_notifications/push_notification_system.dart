import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/chat_message_model.dart';
import '../routes/routes_helper.dart';
import '../utils/app_constants.dart';
import '../helpers/dependencies.dart' as dep;


class PushNotificationSystem{

  BuildContext context;

  PushNotificationSystem({required this.context});

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initializeCloudMessaging() async{

    //1.Terminated
    //cuando la app esta completamente cerrada y abre directamente desde la notificación

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? remoteMessage)
    {
      if(remoteMessage != null){

        final chatMessageModel = ChatMessageModel.fromJson(remoteMessage.data);
        takeToCurrentChat(chatMessageModel);

      }
    });

    //2.Foreground
    //cuando la app esta abierta y recive una notificación
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      if(remoteMessage != null){

        final chatMessageModel = ChatMessageModel.fromJson(remoteMessage.data);
        takeToCurrentChat(chatMessageModel);

      }
    });

    //3.Background
    //cuando la app esta en segundo plano y abre directamente desde la notificación
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      if(remoteMessage != null){

        final chatMessageModel = ChatMessageModel.fromJson(remoteMessage.data);
        takeToCurrentChat(chatMessageModel);

      }
    });

  }

  Future generateMessagingToken() async{

    await FirebaseMessaging.instance.requestPermission();

    String? registrationToken = await messaging.getToken();

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString(AppConstants.FIRESTORE_TOKENS, registrationToken!);

    print("FCM Registration Token: ");
    print(registrationToken);

    messaging.subscribeToTopic("allUser");
    messaging.subscribeToTopic("allTechnicals");
    messaging.subscribeToTopic("all");

  }

  Future<void> takeToCurrentChat(ChatMessageModel chatMessageModel) async{

    Get.toNamed(RouteHelper.getChatConversation(chatMessageModel.senderEmail!,chatMessageModel.senderId!,chatMessageModel.token!));

    /*
    FirebaseFirestore.instance.collection(AppConstants.FIRESTORE_USERS_COLLECTION).doc(chatMessageModel.message).get().then((snapData){
      if(snapData.data()!.length != null){

      }
    });
    */

    /*
    showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) => NotificationDialogBox(
        chatMessageModel: chatMessageModel
    ));
    */

  }

}
