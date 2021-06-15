import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

// Future<void> _firebaseMessagingBackgroundHandler(
//     RemoteMessage remoteMessage) async {
//   //  await Firebase.initializeApp();
//   print('onBackgroundMessage ${remoteMessage.data}');
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, appSnapshot) {
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
              home: appSnapshot.connectionState == ConnectionState.waiting
                  ? SplashScreen()
                  : StreamBuilder(
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SplashScreen();
                        }
                        if (snapshot.hasData) {
                          return ChatScreen();
                        }
                        return AuthScreen();
                      },
                      stream: FirebaseAuth.instance.authStateChanges(),
                    ));
        });
  }
}
