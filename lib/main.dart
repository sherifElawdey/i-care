import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:icare/helper/styles/theme.dart';
import 'package:icare/pages/home/home.dart';
import 'package:icare/pages/reminder_medicine/notification_manager.dart';
import 'package:icare/services/firebase/fire_methods.dart';
import 'package:icare/services/local/sqlite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helper/state/user_controller.dart';
import 'login/welcome_page/welcome_screen.dart';

void main() async{
  FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  await Firebase.initializeApp();
  await DataBaseSql().initializedDatabase();
  await NotificationService().init();
  if(await getTheme()!=null && await getTheme()==true){
    Get.changeThemeMode(ThemeMode.dark);
  }else{
    Get.changeThemeMode(ThemeMode.light);
  }
  runApp(const MyApp());
}
Future getTheme()async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return  prefs.get('dark');
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.leftToRight,
      title: 'I Care',
      onInit: UserController().onInit,
      themeMode: Get.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      home: FirebaseMethods().checkUser() ? const Home() : const WelcomeScreen(),
    );
  }


}