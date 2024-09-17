//Ceci est le code premier du projet app_note c'est a dire le point d'entree

//Importation des bibliotheques
import 'package:app_note/views/auth_views/login_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

//Fonction principale
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
