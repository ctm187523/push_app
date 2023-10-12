

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:push_app/config/router/app_router.dart';



class LocalNotifications {

  //metodo para los permisos para las notificaciones locales
  static Future<void> requestPermissionLocalNotifications() async {

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
    .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission(); //interroganter por si viene nulo
  }

  //metodo para configurar las notificaciones locales 
  static Future<void> initializeNotifications() async {

    final flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();
    
    //inicializacion para Android, el icono lo tomamos de Android/app/src/main/res/drawable
    //de ahy toma los iconos he copiado el que hay en mipmap-xhdpi y lo he puesto en la carpeta drawable
    //cambiando el nombre a app_icon que es el que hemos puesto como argumento del metodo
    const initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

    //TODO ios configuration

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, //ponemos el metodo creado arriba en esta clase para Android
      // Todo ios configuration settings
    );

    await flutterLocalNotificationPlugin.initialize(
      initializationSettings,
      //llamamos al metodo creado abajo, recibimos una respuesta al tocar la notificacion local
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse
      );
   
  }

  //metodo para mostrar las notificaciones locales, recibe 4 parametros 
  static void showLocalNotification( {
    required int id,
    String? title,
    String? body,
    String? data,
  }){

    const androidDetails =  AndroidNotificationDetails(
      'channelId', 
      'channelName',
      playSound: true,
      //he puesto un sonido personalizado, he creado una carpeta llamada raw
      //en --> Android/app/src/main/res/drawable , y ahy he alojado el archivo mp3 notification.mp3
      //que es el archivo que pongo como argumento
      sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max, //se puede cambiar la importancia
      priority: Priority.high //se puede cambiar la prioridad

    );

    const notificationDetails = NotificationDetails(
      android: androidDetails, //usamos la constante credada arriba con los detalles de configuracion
      //TODO IOS
    );

    //para pedir permisos
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    //tomamos los parametros de los parametros recibidos en el metodo
    flutterLocalNotificationsPlugin.show(id, title, body, notificationDetails, payload: data);
  }

  //metodo que recibe una respuesta al tocar la notificacion de haber recibido una local Notification
  static void onDidReceiveNotificationResponse(NotificationResponse response){
    
    //usamos la el payload de la response para redirigir a los detalles de la notificacion cuando pulsamos la notificacion local
    appRouter.push('/push-details/${ response.payload}');
  }
}