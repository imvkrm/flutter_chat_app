import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //if (USE_FIRESTORE_EMULATOR) {
  // FirebaseFirestore.instance.settings = const Settings(
  //   host: 'localhost:8080',
  //   sslEnabled: false,
  //   persistenceEnabled: false,
  // );
  // }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Chat',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          backgroundColor: Colors.pink,
          accentColor: Colors.deepPurple,
          accentColorBrightness: Brightness.dark,
          // buttonTheme: ButtonTheme.of(context).copyWith(
          //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
          // )
        ),
        home: StreamBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
             return ChatScreen();
            }
           return AuthScreen();
          },
          stream: FirebaseAuth.instance.authStateChanges(),
        ));
  }
}
