import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_client/pages/homepage.dart';
import 'package:hostel_client/pages/loginpage.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});
  @override
  State<Registerpage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<Registerpage> {
  bool passwordVisible = false;
  @override
  void initState() {
    super.initState();
    passwordVisible = false;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool validatePassword() {
    if (_passwordController.text == _confirmpasswordController.text) {
      return true;
    }
    return false;
  }

  Future<void> _signUpWithEmailAndPassword(context) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      final User? user = userCredential.user;
      final details = <String, String>{
        "name": _nameController.text,
        "email": _emailController.text,
        "user_id": '${user?.uid}',
      };
      firestore.collection("admin").doc(user?.uid).set(details).onError((e, _) {
        user?.delete();
      });
      print('Signed in: ${user?.uid}');
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const MyHomePage()),
      );
    } catch (e) {
      print('Error signing in: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: !passwordVisible,
          ),
          TextField(
            controller: _confirmpasswordController,
            decoration: const InputDecoration(labelText: 'Confirm Password'),
            obscureText: !passwordVisible,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Checkbox(
                value: passwordVisible,
                onChanged: (bool? newValue) {
                  setState(() {
                    passwordVisible = newValue!;
                  });
                },
              ),
              const Text("Show Password")
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (validatePassword() == true) {
                _signUpWithEmailAndPassword(context);
              }
            },
            child: const Text('Sign Up'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: const Text('Already have a account signin'),
          ),
        ],
      ),
    );
  }
}