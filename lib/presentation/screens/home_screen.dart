

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return ListView.builder(
      itemCount: 0,
      itemBuilder: (BuildContext context, int index ){
      return const ListTile();
      },
    );
  }
}