

import 'package:go_router/go_router.dart';
import 'package:push_app/presentation/screens/details_screen.dart';
import 'package:push_app/presentation/screens/home_screen.dart';

final appRouter = GoRouter(

  routes: [

    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),

     GoRoute(
      path: '/push-details/:messageId',
      //llamamos a la pantalla DetailsScreen y le pasamos por parametro los params recibidos en el Path
      //si no viene mandamos un String vacio, esta pantalla es llamada desde la pantalla home_scree para
      //obtener detalles al pulsar una de las notifiaciones en lista
      builder: (context, state) =>  DetailsScreen(pushMessageId: state.pathParameters['messageId'] ?? ''),
    )
  ]
  
);