import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hostel_client/pages/android_app/firebase_service.dart';
import 'package:hostel_client/pages/android_app/mainpage_parent.dart';
import 'package:permission_handler/permission_handler.dart';

class AppLoginPage extends StatefulWidget {
  const AppLoginPage({super.key});

  @override
  State<AppLoginPage> createState() => _AppLoginPageState();
}

class _AppLoginPageState extends State<AppLoginPage> {

  bool passwordVisible = false;

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  void _saveDeviceToken(String uid,String userType) async {

    String? fcmToken = await _fcm.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = _db
          .collection('users')
          .doc(uid)
          .collection('tokens')
          .doc(fcmToken);

      await tokens.set({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(),
      }).whenComplete((){
        if(userType == "student"){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const FirestoreService())
          );
        }
        if(userType == "parent"){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainPageParent()),
          );
        }
      });
    }
  }
//   _fcm.configure(
//   onMessage: (Map<String, dynamic> message) async {
//   print("onMessage: $message");
//   showDialog(
//   context: context,
//   builder: (context) => AlertDialog(
//   content: ListTile(
//   title: Text(message['notification']['title']),
//   subtitle: Text(message['notification']['body']),
//   ),
//   actions: <Widget>[
//   FlatButton(
//   child: Text('Ok'),
//   onPressed: () => Navigator.of(context).pop(),
//   ),
//   ],
//   ),
//   );
// },
// onLaunch: (Map<String, dynamic> message) async {
// print("onLaunch: $message");
//
// },
// onResume: (Map<String, dynamic> message) async {
// print("onResume: $message");
//
// },
// );

  @override
  void initState() {
    super.initState();
    passwordVisible=true;
    requestPermissions();
  }



  bool validateInputs(){
    if (_passwordController.text.isEmpty || _emailController.text.isEmpty) {
      return false;
    }
    return true;
  }
  void _signIn(String userType,context) async{
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: "2022179017@student.annauniv.edu",
        password: "2022179017",
      );
      final User? user = userCredential.user;
      print('Signed in: ${user?.uid}');
      _saveDeviceToken(user!.uid,userType);
    } catch (e) {
      print('Error signing in: $e');
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextField(
            obscureText: passwordVisible,
            controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(
                          () {
                            passwordVisible = !passwordVisible;
                          },
                        );
                      },
                    ),
                    alignLabelWithHint: false,
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () async{
              // _signInWithEmailAndPassword(context);
              print(await checkEmailType(_emailController.text,context));
            },
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }

  Future<void> requestPermissions() async {
    Permission.ignoreBatteryOptimizations.request();
    Permission.ignoreBatteryOptimizations.request();
    Permission.scheduleExactAlarm.request();
  }

 Future<String> checkEmailType(String email,context) async {
   String userType = "unknown";
   final FirebaseFirestore firestore = FirebaseFirestore.instance;
   QuerySnapshot<Map<String, dynamic>> studentSnapshot = await firestore
       .collection('students')
       .where('email', isEqualTo: "2022179017@student.annauniv.edu")
       .limit(1)
       .get();
   QuerySnapshot<Map<String, dynamic>> parentSnapshot = await firestore
       .collection('students')
       .where('parent_email_id', isEqualTo: email)
       .limit(1)
       .get();

     if (studentSnapshot.docs.isNotEmpty) {
       userType = 'student';
       _signIn(userType,context);
     } else if (parentSnapshot.docs.isNotEmpty){
       userType = 'parent';
       _signIn(userType,context);
     }
   if (!studentSnapshot.docs.isNotEmpty && !parentSnapshot.docs.isNotEmpty) {
     showDialog(
       context: context,
       builder: (BuildContext context) {
         return AlertDialog(
           title: const Text('unknown'),
           content: const Text('Email not found.'),
           actions: [
             TextButton(
               onPressed: () => Navigator.pop(context),
               child: const Text('OK'),
             ),
           ],
         );
       },
     );
     userType = 'unknown';
   }
   print(userType);
   return userType;
 }
}