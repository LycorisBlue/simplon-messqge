import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API PHP Example',
      home: MyHomePage(),
    );
  }
}

class Message {
  final String userId;
  final String message;
  final String date;

  Message({required this.userId, required this.message, required this.date});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      userId: json['user_id2'],
      message: json['messages'],
      date: json['date_msg'],
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String apiUrl = 'http://192.168.1.80/try/send.php'; // Remplacez par votre URL API
  TextEditingController messageController = TextEditingController();
  List<Message> messages = [];

  Future<void> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'user_id': '1', // Vous devrez peut-être envoyer une chaîne pour l'ID
        'message': message
      },
    );

    if (response.statusCode == 200) {
      print('Message envoyé avec succès');
      print('Réponse de l\'API : ${response.body}');
      // Après avoir envoyé le message, mettez à jour la liste de messages
      fetchMessages();
    } else {
      print('Échec de l\'envoi du message. Code de réponse : ${response.statusCode}');
    }
  }

  Future<void> fetchMessages() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        messages = responseData.map((json) => Message.fromJson(json)).toList();
      });
    } else {
      print('Échec de la récupération des messages. Code de réponse : ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Envoi et Récupération de Messages'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index].message),
                  subtitle: Text('User ID: ${messages[index].userId} | Date: ${messages[index].date}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                labelText: 'Entrez votre message',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              sendMessage(messageController.text);
              messageController.clear(); // Effacer le champ après l'envoi
            },
            child: Text('Envoyer le message'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}
