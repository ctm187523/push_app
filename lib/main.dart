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

//IMPORTANTE!!! no funcionaban las versiones del sdk para android
//para arreglarlo visitar esta pagina y ponerlo como el primer ejemplo 
//--> https://stackoverflow.com/questions/71495205/uses-sdkminsdkversion-16-cannot-be-smaller-than-version-19-declared-in-library

void main() {
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
