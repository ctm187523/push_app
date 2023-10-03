import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:push_app/firebase_options.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

//ENVIAR NOTIFICACIONES DESDE FIREBASE
//enviamos notifiaciones desde firebase, vamos donde tenemos el projecto, vamos en el menu de la 
//izquierda a participacion, luego a messaging, luego arriba crear la primera campaña y hacemos check
// en la opcion de arrina Mensajes de Firebase Notifications y pulsamos crear, lo de google analytics
//lo podemos quitar dando a la cruz de la derecha, llenamos el formulario que sera como se vera la notifiacion
//titulo, el body, la imagen no debe pesar mas de 300k
//damos a siguiente, orientacion ponemos para android y cuando ahora, rellenamos finalmente las opciones adicionales
//podemos habilitar el sonido y el vencimiento de la notifiacion, finalmente
//guardamos como borrador,para enviar la notificacion de prueba damos a editar
//en el borrador, arriba a la derecha enviar mensaje de prueba, colocamos el token del dispositivo

//metodo fuera de la clase (top-level function) ver --> https://firebase.flutter.dev/docs/messaging/usage/
//para recibir notificaciones push cuando la aplicacion esta en background y terminada, esta funcion es llamada desde el main
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {

  //propiedades
  //ver --> https://firebase.flutter.dev/docs/messaging/permissions 
  FirebaseMessaging messaging = FirebaseMessaging.instance;  //me permite escuchar y ver mensajeria a traves del objeto creado messaging
  
  //constuctor
  NotificationsBloc() : super(const NotificationsState()) {

    //evento,listener,  que vamos a manejar que es el de tipo NotificationsStatusChanged 
    //creado en la clase NotificationsEvent, para manejar la propiedad del estate AuthorizationStatus
    //como argumento usamos el metodo privado creada abajo _notificationStatusChanged, lo mandamos como 
    //referencia
    on<NotificationsStatusChanged>(_notificationStatusChanged);

    //verifiacion del estado de las notificaciones
    //llamamos al metodo creado abajo en el consturctor despues de la creacion
    //del listener justo arriba
    _initialStatusCheck(); 

    //Listener para notificaciones en Foreground(mientras la app esta activa, en primer plano)
    //llamamos a la funcion creada abajo 
    _onForegroundMessage();  
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
    //llamamos al metodo de abajo para obtener el Token, cuando el estado de la aplicacion cambia
    _getFCMToken(); 
  }

  void _initialStatusCheck() async{
    //usamos el objeto messaging creado arriba de tipo  FirebaseMessaging para obtener el estado
    final settings = await messaging.getNotificationSettings();
    //llamamos al evento para conocer el estado en esta funcion _initialStatusCheck()
    //llamada desde el constructor solo para informarnos del estado, sin llamar el 
    //metodo requestPermission creado abajo
    add( NotificationsStatusChanged(settings.authorizationStatus));
  }

  //metodo para obtener el Token en Firebase, el token sera para el dispositivo donde se usa, la aplicacion
  //siempre tendra el mismo token siempre que no se desinstale y se vuelva a instalar entonces obtendria un nuevo token
  //el token sirve para que desde firebase podamos mandar informacion a un dispositivo con un token en concreto
  //sin ese token no recibira la informacion
  void _getFCMToken() async{

    //nos informamos primero del estado usando el objeto messaging creado arriba de tipo  FirebaseMessaging para que solo reciba
    //el toquen si nuestro estado es autorizado 
     final settings = await messaging.getNotificationSettings();
     if( settings.authorizationStatus != AuthorizationStatus.authorized ) return;

     final token = await messaging.getToken();
     print(token);
  }

  //metodo para recibir notificaciones hacemos en este metodo las de tipo Foreground
  //que son las que recibimos cuando la aplicacion esta activa, hay de tipo Backgroud
  //que es cuando la aplicacion esta en segundo plano y de tipo Terminated cuando la 
  //aplicacion no esta corriendo
  void _handleRemoteMessage( RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification == null) return;
    
    print('Message also contained a notification: ${message.notification}');
    
  }

  //metodo para leer el evento que es un stream con las notificaciones Foreground, al ser un Stream solo
  //lo inicializamos una vez en el cosntructor
  void _onForegroundMessage(){
    //llamamos al metodo creado arriba,codigo copiado de -->  https://firebase.flutter.dev/docs/messaging/usage
    FirebaseMessaging.onMessage.listen(_handleRemoteMessage);
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
