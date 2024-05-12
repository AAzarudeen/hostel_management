import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hostel_client/common/toast.dart';
import 'package:hostel_client/pages/android_app/RcMainPage.dart';
import 'package:hostel_client/pages/android_app/mainpage_parent.dart';
import 'package:hostel_client/pages/android_app/student_dashboard.dart';
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

  void _saveDeviceToken(String uid, String userType,Map<String,dynamic> data) async {
    String? fcmToken = await _fcm.getToken();

    if (fcmToken != null) {
      var tokens =
          _db.collection('users').doc(uid).collection('tokens').doc(fcmToken);
      await tokens.set({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(),
      }).whenComplete(() {
            print("Done");
            print(userType);
      }).onError((error, stackTrace) {
            print(error);
      });
    }
    if (userType == "student") {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>  StudentDashboardPage(student_details: data)));
    }
    if (userType == "parent") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPageParent()),
      );
    }
    if (userType == "RC") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RcMainPage()),
      );
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
    passwordVisible = true;
    requestPermissions();
  }

  bool validateInputs() {
    if (_passwordController.text.isEmpty || _emailController.text.isEmpty) {
      return false;
    }
    return true;
  }

  void _signIn(String email,String password,String userType, context,Map<String,dynamic> data) async {
    if (!validateInputs()) {
      showToast(message: "Please fill all fields", title: 'Error', context: context);
      return;
    }
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;
      print('Signed in: ${user?.uid}');
      _saveDeviceToken(user!.uid, userType,data);
    } catch (e) {
      if(e.toString().contains("invalid-credential")){
        showToast(message: "invalid-credential",title: "Error",context:context);
      }
      if(e.toString().contains("invalid-email")){
        showToast(message: "invalid-email",title: "Error",context:context);
      }
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppLoginContainer();
  }

  Future<void> requestPermissions() async {
    Permission.ignoreBatteryOptimizations.request();
    Permission.ignoreBatteryOptimizations.request();
    Permission.scheduleExactAlarm.request();
  }

  Future<String> checkEmailType(String email, String password,context) async {
    String userType = "unknown";
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> studentSnapshot = await firestore
        .collection('students')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    QuerySnapshot<Map<String, dynamic>> parentSnapshot = await firestore
        .collection('students')
        .where('parent_email_id', isEqualTo: email)
        .limit(1)
        .get();
    QuerySnapshot<Map<String, dynamic>> rcSnapshot = await firestore
        .collection('RC')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    Map<String,dynamic>? data;
    if (studentSnapshot.docs.isNotEmpty) {
      data = studentSnapshot.docs.first.data();
      userType = 'student';
    } else if (parentSnapshot.docs.isNotEmpty) {
      data = parentSnapshot.docs.first.data();
      userType = 'parent';
    }else if (rcSnapshot.docs.isNotEmpty){
      data = rcSnapshot.docs.first.data();
      userType = "RC";
    }
    if (!studentSnapshot.docs.isNotEmpty && !parentSnapshot.docs.isNotEmpty && !rcSnapshot.docs.isNotEmpty) {
      userType = 'unknown';
    }
    _signIn(email,password,userType, context, data!);
    return userType;
  }
  Widget AppLoginContainer(){
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade800,
                Colors.blue.shade600,
                Colors.blue.shade400,
              ],
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32.0),
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 16.0),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextField(
                          obscureText: passwordVisible,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 16.0),
                            suffixIcon: IconButton(
                              icon: Icon(passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                            ),
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                        ),
                        const SizedBox(height: 32.0),
                        ElevatedButton(
                          onPressed: () {
                            checkEmailType("azarcrackzz@gmail.com", "9789291871",context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text('Sign In'),
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
    );
  }
}
