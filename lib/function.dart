import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simplon/box.dart';
import 'dart:convert';

import 'login.dart';


Future<void> registerUser({
  required String name,
  required String lastName,
  required String number,
  required String password,
  required BuildContext context,
}) async {
  final apiUrl =
      'http://192.168.1.77:3000/users'; // Remplacez par l'URL de votre API

  final response = await http.post(
    Uri.parse(apiUrl),
    body: {
      'name': name,
      'lastname': lastName,
      'numero': number,
      'pass': password,
    },
  );

  if (response.statusCode == 201) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              Login()), // Remplacez Signup() par votre page d'inscription
    );
  } else {
  }
}


Future<void> authentificationUser({
  required String number,
  required String password,
  required BuildContext context,
}) async {
  final Box _boxLogin = Hive.box("login");
  final Box _boxUser = Hive.box("user");
  final apiUrl = 'http://192.168.1.77:3000/users/auth'; // Remplacez par l'URL de votre API

  final response = await http.post(
    Uri.parse(apiUrl),
    body: {
      'numero': number,
      'pass': password,
    },
  );

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    // final user = User.fromJson(jsonResponse);

    // Utilisez les variables de l'utilisateur récupérées
    _boxLogin.put("loginStatus", true);
    _boxUser.put("id", jsonData['id']);
    _boxUser.put("name", jsonData['name']);
    _boxUser.put("lastname", jsonData['lastname']);
    _boxUser.put("numero", jsonData['numero']);
    _boxUser.put("password", jsonData['pass']);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MyApp();
        },
      ),
    );
  } else {
  }
}