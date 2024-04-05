import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiservice_app/permissions/permissions.dart';
import 'package:multiservice_app/routes/routes_helper.dart';
import 'helpers/dependencies.dart' as dep;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dep.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    requestLocationPermissions();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      //home: SignInPage(),
      initialRoute: RouteHelper.mainMenu,
      getPages: RouteHelper.routes,
    );
  }

  Future<void> requestLocationPermissions()async{
    requestGeolocationPermissions();
  }

}