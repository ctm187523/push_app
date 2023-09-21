part of 'notifications_bloc.dart';

class NotificationsState extends Equatable {

  final AuthorizationStatus status; //objeto de la clase AuthorizationStatus de firebase_messaging para saber si se puden usar las notificaciones
  final List<dynamic> notifications; //modelo de notificaciones

  //constructor
  const NotificationsState({
    this.status = AuthorizationStatus.notDetermined,
    this.notifications = const[]
  });

  //creamos un copyWith para crear copias del estado
  NotificationsState copyWith({
    AuthorizationStatus? status,
    List<dynamic>? notifications,
  }) => NotificationsState( //si no vienen ya que son opcionales usamos la de la clase
    status: status ?? this.status,
    notifications: notifications ?? this.notifications
  );

  //metodo sobreescrito de la calse Equatable para permitir que dos objetos con las 
  //mismas propiedades se consideren iguales, en el objeto props de abajo ponemos
  //las propiedades que queremos considerar
  @override
  List<Object> get props => [ status, notifications];
}


