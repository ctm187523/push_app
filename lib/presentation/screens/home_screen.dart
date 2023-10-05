

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:push_app/presentation/blocs/bloc/notifications_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //usamos el estado de Bloc para conocer el estado de la autorizacion
        //para poder usar las notificaciones
        title:context.select(
          (NotificationsBloc bloc) => Text('${ bloc.state.status}')
        ),
        actions: [
          IconButton(
            onPressed: (){
              //llamamos al metodo del estado de bloc NotificationsBloc
              //usamos read para que no se redibuje
              context.read<NotificationsBloc>().requestPermission();
            }, 
            icon: const Icon( Icons.settings))
        ],
      ),
      body: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {

  //constructor
  const _HomeView();

  @override
  Widget build(BuildContext context) {

    //llamamos al gestor de estado bloc
    final notifications = context.watch<NotificationsBloc>().state.notifications;
    
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (BuildContext context, int index ){
        final notification = notifications[index];

        return ListTile(
          title: Text(notification.title),
          subtitle: Text(notification.body),
          leading: notification.imageUrl != null
            ? Image.network( notification.imageUrl!)
            : null,
          //al tocar el elemento de la lista usamos Go Router para mandar a la pantalla DetailsScreen
          //pasandole por parametro el id de la notificacion usamos ontap para que se dispare al ser 
          //tocada una de las notificaciones
          onTap: () {
            context.push('/push-details/${ notification.messageId}');
          },
        );
      },
    );
  }
}