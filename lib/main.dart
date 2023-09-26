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

void main() async{

  //usamos en el main la configuracion con Firebase, para ello hemos puesto la funcion main asincrona
  WidgetsFlutterBinding.ensureInitialized();
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
    );
  }
}
