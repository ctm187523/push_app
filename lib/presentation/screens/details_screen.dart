

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_app/domain/entities/push_message.dart';

import '../blocs/bloc/notifications_bloc.dart';

class DetailsScreen extends StatelessWidget {

  //propiedades
  final String pushMessageId;

  //constructor
  const DetailsScreen({super.key, required this.pushMessageId});


  @override
  Widget build(BuildContext context) {

    //accedemos al metodo creado en la clase NotificationsBloc para obtener una notificacion si existe por id
    final PushMessage? message =  context.watch<NotificationsBloc>().getMessageById(pushMessageId);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles Notificación Push'),
      ),
      body: ( message != null)
        ? _DetailsView(message: message)
        : const Center( child: Text('Notificación no existe'))
    );
  }
}

class _DetailsView extends StatelessWidget {

  //propiedades
  final PushMessage message;

  //constructor
  const _DetailsView({required this.message});

  @override
  Widget build(BuildContext context) {

    final textStyles = Theme.of(context).textTheme; 
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [

          if( message.imageUrl != null)
            Image.network(message.imageUrl!),

          const SizedBox( height: 30),

          Text( message.title, style: textStyles.titleMedium),
          Text(message.body),

          const Divider(),
          Text( message.data.toString()),

          Text( message.title, style: textStyles.titleMedium,)
        ]),
    );
  }
}

