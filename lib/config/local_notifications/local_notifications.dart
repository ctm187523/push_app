

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//metodo para los permisos para las notificaciones locales
Future<void> requestPermissionLocalNotifications() async {

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
    .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission(); //interroganter por si viene nulo
}