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


    // on<NotificationsEvent>((event, emit) {
    //   // TODO: implement event handler
    // });
  }

  //metodo estatico para inicializar Firebase sin instanciar la clase al ser estatico
  static Future<void> initializeFCM() async {
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
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

    settings.authorizationStatus;
  }
}
