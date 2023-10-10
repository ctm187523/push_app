import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_app/config/router/app_router.dart';
import 'package:push_app/presentation/blocs/bloc/notifications_bloc.dart';
import 'config/theme/app_theme.dart';

//instalamos las siguientes dependencias
// flutter pub add go_router   --para manaejar las diferentes pantallas
// flutter pub add equatable   --para poder tener mismos objetos si contienen las mismas propiedades
// flutter pub add flutter_bloc  --para el provider, manejador de estados
// flutter pub add firebase_messaging --para manejar las notificaciones

//IMPORTANTE!!! no funcionaban las versiones del sdk para android minimo
//para arreglarlo visitar esta pagina y ponerlo como el primer ejemplo 
//--> https://stackoverflow.com/questions/71495205/uses-sdkminsdkversion-16-cannot-be-smaller-than-version-19-declared-in-library
//o ver video siguiente al final que tambien lo resuelve

//Instalamos firebase cli ver video configurar proyecto firebase

//cambiamos identificador app por una personalizada ver video Cambiar id de la Aplicacion

//instalamos el core de Firebase --> flutter pub add firebase_core

//inicializamos FlutterFire CLI con --> dart pub global activate flutterfire_cli
//lo configuramos con --> flutterfire configure
//antes he tenido que añadir la variable de entorno ver --> https://stackoverflow.com/questions/71487625/how-can-i-resolve-zsh-command-not-found-flutterfire-in-macos
//una vez iniciado con la instruccion flutterfire configure seleccionamos el id del proyecto que tenemos
//en firebase si no se sabe el id ir a Firebase y mirarlo en mid proyectos creados
//seguimos las instrucciones de configuracion y nos crea en la carpeta lib del proyecto el archivo firebase_options.dart
//donde configura las apiKey, apiId etc. automaticamente para android i ios


//para enviar las notificaciones necesitamos crear un bearer token para ello usamos en el directorio del ordenador Flutter/firebase-get-bearer-token
//de Fernando Herrera y seguimos las instruccionesd del Readme
//en la web --> https://console.firebase.google.com/project/flutter-projects-58fe8/settings/serviceaccounts/adminsdk?hl=es-419 creamos una clave privada necesaria para llevar a cabo el envio de notificaciones
//ver video Servidor para obtener Bearer Token en el curso
//para enviar notificaciones ver video Rest-Forma recomendada

//en la seccion 23 instalamos las flutter_local_notificationc con -->flutter pub add flutter_local_notifications
//estas son notificaciones de tipo local no vienen de un servidor
//ver --> https://pub.dev/packages/flutter_local_notifications#gradle-setup 
//para los pasos a seguir de configuracion de notificaciones locales

void main() async{

  //usamos en el main la configuracion con Firebase, para ello hemos puesto la funcion main asincrona
  WidgetsFlutterBinding.ensureInitialized();
  //llamamos a la funcion firebaseMessagingBackgroundHandler creada al inicio en la clase NotificationsBloc
  //es el registro de la funcion
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await NotificationsBloc.initializeFCM(); //llamamos al metodo estatico creado en NotificationsBloc para iniciar Firebase

  //ponemos el bloc para controlar el estado en el punto mas alto de la aplicacion
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NotificationsBloc())
      ], 
      child: const MainApp())
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
      //llamamos en el buider la clase creada abajo
      builder: (context, child) => HandleNotificationInteractionState(child: child!),
    );
  }
}

//creamos esta clase para que cuando recibamos uan notificacion y la aplicacion no este en foreground(no esta en primer plano)
//al clickar en la notificacion nos mande directamente a la pagina de details_screen sin pasar por el HomeScreen 
//basado en --> https://firebase.flutter.dev/docs/messaging/notifications
class HandleNotificationInteractionState extends StatefulWidget {

  //propiedades
  final Widget child; //el child al ser un widget lo usamos en el buid de la clase

  //constructor
  const HandleNotificationInteractionState({ super.key, required this.child});

  @override
  State<HandleNotificationInteractionState> createState() => __HandleNotificationInteractionStateState();
}

class __HandleNotificationInteractionStateState extends State<HandleNotificationInteractionState> {
  
    // It is assumed that all messages contain a data field with the key 'type'
    Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }
  
  void _handleMessage(RemoteMessage message) {

    //usamos el read porque nos encontramos en un metodo, usamos la clase publica handleRemoteMessage
    //de NotificationsBloc 
    context.read<NotificationsBloc>().handleRemoteMessage(message);
    
    //obtenemos el id del message recibido sustituyendo los caracteres especiales que nos pueden dar
    //problemas para usar Go Router
    final messageId = message.messageId?.replaceAll(':', '').replaceAll('%', '');
    
    //usamos GoRouter y dirigimos a la pagina DetailsScreen
    appRouter.push('/push-details/$messageId');
  }

  @override
  void initState() {
    super.initState();

    // Run code required to handle interacted messages in an async function
    // as initState() must not be async
    setupInteractedMessage();
  }
  
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
