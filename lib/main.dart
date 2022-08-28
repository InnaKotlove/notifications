import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NotificationApp(),
    );
  }
}

class NotificationApp extends StatefulWidget {
  const NotificationApp({Key? key}) : super(key: key);

  @override
  _NotificationAppState createState() => _NotificationAppState();
}

class _NotificationAppState extends State<NotificationApp> {
  //объект уведомления - экземпляр
  late FlutterLocalNotificationsPlugin localNotifications;

  //инициализация
  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Kiev'));
    //объект для Android настроек
    var androidInitialize = new AndroidInitializationSettings('ic_launcher');
    //объект для IOS настроек
    var IOSInitialize = new IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    // общая инициализация
    var initializationSettings = new InitializationSettings(
        android: androidInitialize, iOS: IOSInitialize);

    //создаем локальное уведомление
    localNotifications = new FlutterLocalNotificationsPlugin();
    localNotifications.initialize(initializationSettings);
  }

  Future _showNotification() async {
    var androidDetails = new AndroidNotificationDetails(
      "ID",
      "Выделить полчаса на занятия программированием",
      importance: Importance.high,
      channelDescription: "Контент уведомления",
    );
    var iosDetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iosDetails);
    await localNotifications.zonedSchedule(
        0,
        "Напоминаниее",
        "Выделить полчаса на занятия программированием",
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        generalNotificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Нажми на кнопку, чтобы получить уведомление'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNotification,
        child: Icon(Icons.notifications),
      ),
    );
  }
}
