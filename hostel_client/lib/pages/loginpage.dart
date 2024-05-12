// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:hostel_client/common/UserProvider.dart';
// import 'package:hostel_client/common/toast.dart';
// import 'package:hostel_client/pages/homepage.dart';
// import 'package:hostel_client/pages/registerpage.dart';
// import 'package:provider/provider.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//
//  bool passwordVisible = false;
//     @override
//     void initState(){
//       super.initState();
//       passwordVisible=true;
//     }
//
//   bool validateInputs(){
//     if (_passwordController.text.isEmpty || _emailController.text.isEmpty) {
//       return false;
//     }
//     return true;
//   }
//
//   Future<void> _signInWithEmailAndPassword(context) async {
//     if(!validateInputs()){
//       showToast(message: "Please fill all fields", title: 'Error',context: context);
//       return;
//     }
//     try {
//       final UserCredential userCredential =
//           await _auth.signInWithEmailAndPassword(
//         email: _emailController.text,
//         password: _passwordController.text,
//       );
//       final User? user = userCredential.user;
//       Provider.of<UserProvider>(context, listen: false).setCurrentUser(user!);
//       print('Signed in: ${user.uid}');
//       Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => const MyHomePage()),
//                 );
//     } catch (e) {
//       print('Error signing in: $e');
//     }
//   }
//
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           TextField(
//             controller: _emailController,
//             decoration: const InputDecoration(labelText: 'Email'),
//           ),
//           TextField(
//             obscureText: passwordVisible,
//             controller: _passwordController,
//                   decoration: InputDecoration(
//                     labelText: "Password",
//                     suffixIcon: IconButton(
//                       icon: Icon(passwordVisible
//                           ? Icons.visibility
//                           : Icons.visibility_off),
//                       onPressed: () {
//                         setState(
//                           () {
//                             passwordVisible = !passwordVisible;
//                           },
//                         );
//                       },
//                     ),
//                     alignLabelWithHint: false,
//                   ),
//                   keyboardType: TextInputType.visiblePassword,
//                   textInputAction: TextInputAction.done,
//                 ),
//           const SizedBox(height: 30),
//           ElevatedButton(
//             onPressed: () {
//               _signInWithEmailAndPassword(context);
//             },
//             child: const Text('Sign In'),
//           ),
//           const SizedBox(height: 30),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const Registerpage()),
//               );
//             },
//             child: const Text('create account'),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_client/common/UserProvider.dart';
import 'package:hostel_client/common/toast.dart';
import 'package:hostel_client/pages/homepage.dart';
import 'package:hostel_client/pages/registerpage.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passwordVisible = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool validateInputs() {
    if (_passwordController.text.isEmpty || _emailController.text.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> _signInWithEmailAndPassword(context) async {
    if (!validateInputs()) {
      showToast(message: "Please fill all fields", title: 'Error', context: context);
      return;
    }
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      final User? user = userCredential.user;
      Provider.of<UserProvider>(context, listen: false).setCurrentUser(user!);
      print('Signed in: ${user.uid}');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    } catch (e) {
      if(e.toString().contains("invalid-credential")){
        showToast(message: "invalid-credential",title: "Error",context:context);
      }
      if(e.toString().contains("invalid-email")){
        showToast(message: "invalid-email",title: "Error",context:context);
      }
      print('Error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          'Hostel Management Admin login',
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
                          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
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
                          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                          suffixIcon: IconButton(
                            icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
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
                          _signInWithEmailAndPassword(context);
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
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Registerpage()),
                          );
                        },
                        child: const Text('Create Account'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}