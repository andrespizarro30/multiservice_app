import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:multiservice_app/controllers/authentication_controller.dart';
import 'package:multiservice_app/controllers/main_page_controller.dart';
import 'package:multiservice_app/controllers/multiporpuse_form_page_controller.dart';
import 'package:multiservice_app/controllers/select_address_page_controller.dart';
import 'package:multiservice_app/pages/authentication/sign_in_page.dart';
import 'package:multiservice_app/pages/main_pages/main_menu_all_options.dart';
import 'package:multiservice_app/pages/main_pages/main_menu_page.dart';
import 'package:multiservice_app/pages/service_required/accepted_services.dart';
import 'package:multiservice_app/pages/service_required/pending_services.dart';
import 'package:multiservice_app/routes/routes_helper.dart';
import 'package:multiservice_app/widgets/icon_text_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../push_notifications/push_notification_system.dart';
import '../../utils/colors.dart';
import '../../utils/dimension.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import '../../widgets/small_text.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  TextEditingController insertNewAddresTextController = TextEditingController();

  int _selectedIndex = 0;

  late PersistentTabController persistentTabController;

  List<Widget> _pages=[
    MainMenuAllOptions(),
    PendingServices(),
    AcceptedServices()
  ];

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home),
        title: ("Home"),
        activeColorPrimary: AppColors.mainColor,
        inactiveColorPrimary: Colors.redAccent,
      ),
      PersistentBottomNavBarItem(
        icon: GetBuilder<MultiPorpuseFormPageController>(builder: (controller){
          return Stack(
            children: [
              Icon(Icons.pending_actions),
              controller.pendingServicesList.isNotEmpty ?
              Positioned(
                  right: 0,
                  top: 0,
                  child: ApplIcon(
                    icon: Icons.circle,
                    size: 16,
                    iconColor: Colors.transparent,
                    backgroundColor: Colors.red,
                  )
              ) :
              Container(),
              controller.pendingServicesList.isNotEmpty ?
              Positioned(
                right: 3,
                top: 3,
                child: SmallText(
                  text: Get.find<MultiPorpuseFormPageController>().pendingServicesList.length.toString(),
                  color: Colors.white,
                  size: 8,
                ),
              ) :
              Container()
            ],
          );
        }),
        title: ("Pendientes"),
        activeColorPrimary: AppColors.mainColor,
        inactiveColorPrimary: Colors.redAccent,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.check_mark_circled_solid),
        title: ("Aceptados"),
        activeColorPrimary: AppColors.mainColor,
        inactiveColorPrimary: Colors.redAccent,
      )
    ];
  }

  void onTabNav(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState(){
    // TODO: implement initState
    super.initState();

    persistentTabController = PersistentTabController(initialIndex: 0);

    Get.find<AuthenticationPageController>().verifyCurrentUser();
    Get.find<MainPageController>().getCurrentAddress();
    Get.find<MultiPorpuseFormPageController>().getPendingServices();

    initNotificationService();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasData){
            return GetBuilder<AuthenticationPageController>(builder: (authController){
              return authController.uid != "" || authController.currentFBUserExists ?

                GetBuilder<MainPageController>(builder: (controller){

                return PersistentTabView(
                  context,
                  controller: persistentTabController,
                  screens: _pages,
                  items: _navBarsItems(),
                  confineInSafeArea: true,
                  backgroundColor: Colors.white, // Default is Colors.white.
                  handleAndroidBackButtonPress: true, // Default is true.
                  resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
                  stateManagement: true, // Default is true.
                  hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
                  decoration: NavBarDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    colorBehindNavBar: Colors.white,
                  ),
                  popAllScreensOnTapOfSelectedTab: true,
                  popActionScreens: PopActionScreensType.all,
                  itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
                    duration: Duration(milliseconds: 200),
                    curve: Curves.ease,
                  ),
                  screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
                    animateTabTransition: true,
                    curve: Curves.ease,
                    duration: Duration(milliseconds: 200),
                  ),
                  navBarStyle: NavBarStyle.style1, // Choose the nav bar style with this property.
                );
              }) :
                  SignInPage();
            });
          }else{
            return SignInPage();
          }
        },
      )
    );

  }

  void initNotificationService() async{

    PushNotificationSystem pushNotificationSystem = PushNotificationSystem(context: context);
    pushNotificationSystem.initializeCloudMessaging();
    pushNotificationSystem.generateMessagingToken();

  }

}
