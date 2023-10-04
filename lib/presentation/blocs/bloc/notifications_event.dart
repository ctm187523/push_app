part of 'notifications_bloc.dart';

//he quitado que el extends para que no herede de Equatable como viene por defecto

//esta clase se encarga de manejar los eventos para controlar cuando se realizan
//los cambios de estado
class NotificationsEvent{
  const NotificationsEvent();
}

//creamos una clase que hereda de la clase principal de arriba
//para manejar los cambios en la propiedad del state AuthorizationStatus
class NotificationsStatusChanged extends NotificationsEvent {

  //propiedades
  final AuthorizationStatus status; //objeto AuthorizationStatus del state

  //constructor
  NotificationsStatusChanged(this.status);
}

//creamos una clase que recibe los PushMessage del notifications_bloc
class NotificationReceived extends NotificationsEvent {

  final PushMessage notification;

  NotificationReceived(this.notification);
}