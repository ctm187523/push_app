part of 'notifications_bloc.dart';

class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  //metodo sobreescrito de la calse Equatable para permitir que dos objetos con las 
  //mismas propiedades se consideren iguales, en el objeto props de abajo ponemos
  //las propiedades que queremos considerar
  @override
  List<Object> get props => [];
}
