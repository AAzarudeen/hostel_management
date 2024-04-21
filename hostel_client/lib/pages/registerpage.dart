import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_client/common/toast.dart';
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

  Future<void> _signUpWithEmailAndPassword(context) async {
    if (_passwordController.text != _confirmpasswordController.text) {
      showToast(title: "Error", message: "Password don't match", context: context);
      return;
    }
    if (_nameController.text.isEmpty || _passwordController.text.isEmpty || _emailController.text.isEmpty || _confirmpasswordController.text.isEmpty) {
      showToast(title: "Error", message: "Please fill all the details", context: context);
      return;
    }
    try {
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ).then((userCredential) {
            final User? user = userCredential.user;
            final details = <String, String>{
              "name": _nameController.text,
              "email": _emailController.text,
              "user_id": '${user?.uid}',
            };
            firestore.collection("admin").doc(user?.uid).set(details).whenComplete((){
              showToast(title: "Success", message: "Account created", context: context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyHomePage()),
              );
            }).onError((e, _) {
              user?.delete();
            });
          });
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
                _signUpWithEmailAndPassword(context);
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