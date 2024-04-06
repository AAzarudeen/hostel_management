import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_client/pages/android_app/mainpage_parent.dart';

class AppLoginPage extends StatefulWidget {
  const AppLoginPage({super.key});

  @override
  State<AppLoginPage> createState() => _AppLoginPageState();
}

class _AppLoginPageState extends State<AppLoginPage> {

 bool passwordVisible = false;
    @override
    void initState(){
      super.initState();
      passwordVisible=true;
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
        email: _emailController.text,
        password: _passwordController.text,
      );
      final User? user = userCredential.user;
      print('Signed in: ${user?.uid}');
      if(userType == "student"){

      }
      if(userType == "parent"){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPageParent()),
        );
      }
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

 Future<String> checkEmailType(String email,context) async {
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