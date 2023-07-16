import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:icare/modules/reminder.dart';
import 'package:icare/pages/reminder_medicine/reminder_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  //Singleton pattern
  static final NotificationService _notificationService =
  NotificationService._internal();
  factory NotificationService() {
    return _notificationService;
  }
  NotificationService._internal();

  //instance of FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void onSelectNotification(NotificationResponse notificationResponse){
    print('Notification clicked');
    Get.to(ReminderScreen());
  }

  Future<void> init() async {
    // flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();
    //Initialization Settings for Android
    var initializationSettingsAndroid = const AndroidInitializationSettings('background');
    //Initialization Settings for iOS
    var initializationSettingsIOS = const DarwinInitializationSettings();

    //InitializationSettings for initializing settings for both platforms (Android & iOS)
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: onSelectNotification,
    );

  }
  AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
    'channel ID',
    'channel name',
    playSound: true,
    priority: Priority.high,
    importance: Importance.max,
  );

  final DarwinNotificationDetails iOSNotificationDetails =const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
  );


  void showNotificationDaily(ReminderModel reminder) async {

    var time = Time(int.parse(reminder.hour.toString()), int.parse(reminder.minute.toString()), 0);
    var dateNow=DateTime.now();
    var date =DateTime(
      dateNow.year,
      dateNow.month,
      dateNow.day,
      int.parse(reminder.hour.toString()),
      int.parse(reminder.minute.toString()),
    );
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        reminder.id ?? 1,
        'Reminder : ${reminder.name}',
        'it\'s Time to take ${reminder.amount} of ${reminder.name}',
        time,
        NotificationDetails(
            android: androidNotificationDetails,
            iOS: iOSNotificationDetails
        ),
    );
    /*await flutterLocalNotificationsPlugin.zonedSchedule(
        reminder.id??1,
        'Reminder : ${reminder.name}',
        'it\'s Time to take ${reminder.amount} of ${reminder.name}',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10)),
        NotificationDetails(
          android: androidNotificationDetails,
          iOS: iOSNotificationDetails
        ),
        uiLocalNotificationDateInterpretation:  UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
    );*/

    print('Notification Successfully Scheduled at ${time.toString()}');
  }

  Future<void> cancelNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

}


class NotificationService2 {
  //Singleton pattern
  static final NotificationService2 _notificationService =
  NotificationService2._internal();
  factory NotificationService2() {
    return _notificationService;
  }
  NotificationService2._internal();

  //instance of FlutterLocalNotificationsPlugin
  final AndroidFlutterLocalNotificationsPlugin flutterLocalNotificationsPluginAndroid = AndroidFlutterLocalNotificationsPlugin();
  final IOSFlutterLocalNotificationsPlugin flutterLocalNotificationsPluginIos = IOSFlutterLocalNotificationsPlugin();

  void onSelectNotification(NotificationResponse notificationResponse){
    print('Notification clicked');
    Get.to(ReminderScreen());
  }

  Future<void> init() async {
    //Initialization Settings for Android
    var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/launcher_icon');
    //Initialization Settings for iOS
    var initializationSettingsIOS = const DarwinInitializationSettings();

    //InitializationSettings for initializing settings for both platforms (Android & iOS)
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    tz.initializeTimeZones();
    if(Platform.isAndroid){
      try{
        await flutterLocalNotificationsPluginAndroid.initialize(
          initializationSettingsAndroid,
          onDidReceiveNotificationResponse: onSelectNotification,
          onDidReceiveBackgroundNotificationResponse: onSelectNotification,
        );
      }catch(e){
        print('error   :  $e');
      }
    }else{
      await flutterLocalNotificationsPluginIos.initialize(
        initializationSettingsIOS,
        onDidReceiveNotificationResponse: onSelectNotification,
        onDidReceiveBackgroundNotificationResponse: onSelectNotification,
      );
    }

  }
  AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
    'channel ID',
    'channel name',
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
  );

  final DarwinNotificationDetails iOSNotificationDetails =const DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );


  void showNotificationDaily(ReminderModel reminder) async {

    var time = Time(int.parse(reminder.hour.toString()), int.parse(reminder.minute.toString()), 0);
    if(Platform.isAndroid){
      await flutterLocalNotificationsPluginAndroid.zonedSchedule(
        reminder.id??1,
        'Reminder : ${reminder.name}',
        'it\'s Time to take ${reminder.amount} of ${reminder.name}',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        androidNotificationDetails,
        androidAllowWhileIdle: true,
      );
    }else{
      await flutterLocalNotificationsPluginIos.zonedSchedule(
          reminder.id??1,
          'Reminder : ${reminder.name}',
          'it\'s Time to take ${reminder.amount} of ${reminder.name}',
          tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
          iOSNotificationDetails,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
      );
    }


    print('Notification Successfully Scheduled at ${time.toString()}');
  }

  Future<void> cancelNotifications(int id) async {
    if(Platform.isAndroid){
      await flutterLocalNotificationsPluginAndroid.cancel(id);

    }else{
      await flutterLocalNotificationsPluginIos.cancel(id);
    }
  }

  Future<void> cancelAllNotifications() async {
    if(Platform.isAndroid){
      await flutterLocalNotificationsPluginAndroid.cancelAll();

    }else{
      await flutterLocalNotificationsPluginIos.cancelAll();
    }
  }

}





// class NotificationManager {
//   var flutterLocalNotificationsPlugin;
//
//   NotificationManager() {
//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     Future.wait([initNotifications()]);
//   }
//
//   getNotificationInstance() {
//     return flutterLocalNotificationsPlugin;
//   }
//
//   Future initNotifications() async{
//     var initializationSettingsAndroid =
//         const AndroidInitializationSettings('@mipmap/launcher_icon');
//     var initializationSettingsIOS = const DarwinInitializationSettings();
//
//     var initializationSettings = InitializationSettings(
//         android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
//
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: onSelectNotification);
//   }
//
//   Future onSelectNotification(String payload) async {
//     print('Notification clicked');
//     Get.to(ReminderScreen());
//   }
//
//   void showNotificationDaily(ReminderModel reminder) async {
//     var time = Time(int.parse(reminder.hour.toString()), int.parse(reminder.minute.toString()), 0);
//     await flutterLocalNotificationsPlugin.showDailyAtTime(
//       reminder.id,
//       'Reminder : ${reminder.name}',
//       'it\'s Time to take ${reminder.amount} of ${reminder.name}',
//       time,
//       getPlatformChannelSpecifics(),
//     );
//
//     print('Notification Succesfully Scheduled at ${time.toString()}');
//   }
//
//   getPlatformChannelSpecifics() {
//     var androidPlatformChannelSpecifics =const AndroidNotificationDetails(
//         'your channel id', 'your channel name',
//         importance: Importance.max,
//         priority: Priority.high,
//         ledColor: Colors.blue,
//         ledOffMs: 1000,
//         ledOnMs: 1000,
//         enableLights: true,
//         ticker: 'Medicine Reminder');
//     var iOSPlatformChannelSpecifics =const DarwinNotificationDetails();
//     var platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//       iOS: iOSPlatformChannelSpecifics,
//     );
//
//     return platformChannelSpecifics;
//   }
//
//
//   Future onDidReceiveLocalNotification(
//       int id, String title, String body, String payload) async {
//     return Future.value(1);
//   }
//
//   void removeReminder(int notificationId) {
//     flutterLocalNotificationsPlugin.cancel(notificationId);
//   }
// }
