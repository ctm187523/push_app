import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:push_app/firebase_options.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {

  //propiedades
  //ver --> https://firebase.flutter.dev/docs/messaging/permissions 
  FirebaseMessaging messaging = FirebaseMessaging.instance;  //me permite escuchar y ver mensajeria a traves del objeto creado messaging
  
  //constuctor
  NotificationsBloc() : super(const NotificationsState()) {

    //evento que vamos a manejar que es el de tipo NotificationsStatusChanged 
    //creado en la clase NotificationsEvent, para manejar la propiedad del estate AuthorizationStatus
    //como argumento usamos el metodo privado creada abajo _notificationStatusChanged, lo mandamos como 
    //referencia
    on<NotificationsStatusChanged>(_notificationStatusChanged);
  }

  //metodo estatico para inicializar Firebase sin instanciar la clase al ser estatico
  static Future<void> initializeFCM() async {
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  //creamos un metodo privado(_) para manejar el evento del cambio de estado de la propiedad del
  //state AuthorizationStatus, en el primer parametro event usamos un objeto de la clase NotificationsStatusChanged 
  //creada en la clase NotificationsEvent
  void _notificationStatusChanged(NotificationsStatusChanged event,Emitter<NotificationsState> emit) {
    //emitimos el nuevo valor del status, usando el argumento event recibido
    emit(
      state.copyWith(
        status: event.status
      )
    );
  }

  //metodos de gestor de estado
  //ver --> https://firebase.flutter.dev/docs/messaging/permissions 
  //metodo que es llamado cuando tocamos en la pantalla el engranaje de settings
  void requestPermission() async {
    
    //configuramos las notificaciones
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true, 
      carPlay: false, 
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    //con add llamamos al evento creado en la clase NotificationStatusChanged
    //dentro de la clase  NotificationsEvent
    add( NotificationsStatusChanged(settings.authorizationStatus));
    
  }
}
