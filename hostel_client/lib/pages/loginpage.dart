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

  Future<void> _signInWithEmailAndPassword(context) async {
    if(!validateInputs()){
      showToast(message: "Please fill all fields", title: 'Error',context: context);
      return;
    }
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
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
            onPressed: () {
              _signInWithEmailAndPassword(context);
            },
            child: const Text('Sign In'),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Registerpage()),
              );
            },
            child: const Text('create account'),
          ),
        ],
      ),
    );
  }
}