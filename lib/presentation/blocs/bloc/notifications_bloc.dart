import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:push_app/config/local_notifications/local_notifications.dart';
import 'package:push_app/domain/entities/push_message.dart';
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
  
  int pushNumberId = 0; //contador para los id de las notificaciones locales
  
  //propiedades
  //funcion para manejar los permisos de las notificaciones locales, puede ser opcional ?
  final Future<void> Function()? requestLocalNotificationsPermissions;
  //funcion para mostrar las notificaciones, puede ser opcional
  final void Function({required int id, String? title,String? body,String? data,
  })? showLocalNotification; 



  //constuctor
  NotificationsBloc({
    this.requestLocalNotificationsPermissions,
    this.showLocalNotification
  }) : super(const NotificationsState()) {

    //evento,listener,  que vamos a manejar que es el de tipo NotificationsStatusChanged 
    //creado en la clase NotificationsEvent, para manejar la propiedad del estate AuthorizationStatus
    //como argumento usamos el metodo privado creada abajo _notificationStatusChanged, lo mandamos como 
    //referencia
    on<NotificationsStatusChanged>(_notificationStatusChanged);

    //Creamos el listener para estar a la escucha de las notificaciones, 
    on<NotificationReceived>(_onPushMessageReceived);

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

  //manejamos el evento para el array de notificacioens de tipo PushMessage
  void _onPushMessageReceived(NotificationReceived event, Emitter<NotificationsState> emit){

    emit(
      state.copyWith(
        //usamos el spread para crear un nuevo estado
        notifications: [ event.notification, ...state.notifications]
      )
    );
  }

  //metodo para obtener el estado actual
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
  //el metodo es publico lo usa en el main en la clase HandleNotificationInteractionState
  void handleRemoteMessage( RemoteMessage message) {
   
    if (message.notification == null) return;
    
    //usamos la entidad la clase creada en domain(entities)
    final notification = PushMessage(
      //puede ser opcional, tratamos la respuesta usando replaceAll para que luego cuando usemos
      //goRouter no de problemas y venga sin caracteres especiales, si no viene creamos un String vacio
      messageId: message.messageId
       ?.replaceAll(':', '').replaceAll('%','')
       ?? '',
      title: message.notification!.title ?? '', //si no viene String vacio
      body: message.notification!.body ?? '',
      sentDate: message.sentTime ?? DateTime.now(),
      data: message.data,
      imageUrl: Platform.isAndroid //discriminamos si es Android o Apple la plataforma
        ? message.notification!.android?.imageUrl
        : message.notification!.apple?.imageUrl
    );
    
    //mandamos el objeto PushMessage(notification)
    add(NotificationReceived(notification));

    //llamamos al metodo showLocalNotification recibido por parametro para gestionar las notificaciones locales, si no es nulo
    if(showLocalNotification != null){
        showLocalNotification!(
        id: ++pushNumberId, //usamso al variable creada al inicio, lo decrementa y luego lo utiliza
        body: notification.body,
        data: notification.messageId, //lo usamos para identificar las notificaciones locales y asi poder redirigirlas con goRouter para ver los detalles de la notificacion
        title: notification.title,
        );
    }
   
  }

  //metodo para leer el evento que es un stream con las notificaciones Foreground, al ser un Stream solo
  //lo inicializamos una vez en el cosntructor
  void _onForegroundMessage(){
    //llamamos al metodo creado arriba,codigo copiado de -->  https://firebase.flutter.dev/docs/messaging/usage
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
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
    
    //si la propiedad para los permisos de las notificaciones locales no viene vacio
    //hacemos un await a ese metodo
    if (requestLocalNotificationsPermissions != null){
      await requestLocalNotificationsPermissions!();
    }

    //con add llamamos al evento creado en la clase NotificationStatusChanged
    //dentro de la clase  NotificationsEvent
    add( NotificationsStatusChanged(settings.authorizationStatus));
  }

  //metodo para obtener una notificacion push(de tipo PushMessage) si existe
  PushMessage? getMessageById( String pushMessageId) {

    //evaluamos si exite alguna notificacion que tenga el id que recibimos por parametro en la funcion
    //usamos el metodo any de la clase Iterable para buscar si existe una notifiacion de tipo PushMeassage con ese Id
    final exist = state.notifications.any((element) => element.messageId == pushMessageId);
    if ( !exist ) return null;

    //si existe devolvemos la notificacion de tipo PushMessage,
    //usamos el metodo firstWhere de la clase Iterable para buscar la notificacion
    return state.notifications.firstWhere((element) => element.messageId == pushMessageId);
  }
}
