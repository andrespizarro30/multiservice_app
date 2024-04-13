import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:multiservice_app/routes/routes_helper.dart';
import 'helpers/dependencies.dart' as dep;
import 'local_notifications/local_notification_service.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dep.init();
  await LocalNotificationService().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      //home: SignInPage(),
      initialRoute: RouteHelper.getMain(),
      getPages: RouteHelper.routes,
    );
  }

}