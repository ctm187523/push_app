
//creamos una clase para manejar las notificaciones recibidas
class PushMessage {

  final String messageId;
  final String title;
  final String body;
  final DateTime sentDate; //fecha de creacion
  final Map<String, dynamic>? data;  //son las opciones adicionales
  final String? imageUrl;

  //constructor
  PushMessage({
    required this.messageId,
    required this.title, 
    required this.body, 
    required this.sentDate, 
    this.data, 
    this.imageUrl
  });

  //sobreescribimos el metodo toString para que al imprimir el objeto
  //PushMessage aparezca la informacion que contiene
  @override
  String toString() { 
     return '''
PushMessage -
    id: $messageId
    title: $title 
    body: $body
    data: $data
    imageUrl: $imageUrl
    sentDate: $sentDate
''';
  }
}