import 'package:flutter/material.dart';
import 'package:push_app/config/router/app_router.dart';
import 'config/theme/app_theme.dart';

//instalamos las siguientes dependencias
// flutter pub add go_router   --para manaejar las diferentes pantallas
// flutter pub add equatable   --para poder tener mismos objetos si contienen las mismas propiedades
// flutter pub add flutter_bloc  --para el provider, manejador de estados

void main() {
  runApp(const MainApp());
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
