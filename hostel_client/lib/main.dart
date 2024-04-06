import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hostel_client/pages/android_app/app_login.dart';
import 'package:hostel_client/pages/android_app/mappage.dart';
import 'package:hostel_client/pages/homepage.dart';
import 'package:hostel_client/pages/loginpage.dart';
import 'package:hostel_client/pages/registerpage.dart';

import 'firebase_options.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyD5Az3xNubVJpGkE9uzT8k_5ZT5OZdI6f0",
          authDomain: "dummy-8a0cb.firebaseapp.com",
          projectId: "dummy-8a0cb",
          storageBucket: "dummy-8a0cb.appspot.com",
          messagingSenderId: "781902418314",
          appId: "1:781902418314:web:4643406acf805c511a3873",
          measurementId: "G-1EF7HMPKPT"),
    );
    runApp(const WebPages());
  } else {
    print("Hello");
    await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
    runApp(const AppPages());
  }
}
class AppPages extends StatelessWidget {
  const AppPages({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppLoginPage(),
    );
  }
}


class WebPages extends StatelessWidget {
  const WebPages({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
      routes: {
        '/login':(context) => const LoginPage(),
        // '/register':(context) => const Registerpage(),
        '/homepage':(context) => const MyHomePage()
      },
    );
  }
}