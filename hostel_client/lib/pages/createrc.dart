import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateRC extends StatefulWidget {
  const CreateRC({super.key});

  @override
  State<CreateRC> createState() => _CreateRcState();
}

class _CreateRcState extends State<CreateRC> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _blockController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create RC'),
        ),
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
                                TextField(
                                  controller: _nameController,
                                  decoration:
                                      const InputDecoration(labelText: 'Name'),
                                ),
                                TextField(
                                  controller: _blockController,
                                  decoration:
                                      const InputDecoration(labelText: 'Block'),
                                ),
                                TextField(
                                  controller: _emailController,
                                  decoration:
                                      const InputDecoration(labelText: 'Email'),
                                ),
                                TextField(
                                  controller: _phoneController,
                                  decoration: const InputDecoration(
                                      labelText: 'Phone Number'),
                                ),
                                const SizedBox(height: 20.0),
                                ElevatedButton(
                                  onPressed: () {
                                    _saveResident();
                                  },
                                  child: const Text('Save Resident Controller'),
                                ),
                              ],
                            ),
                          ),
                        ))))));
  }

  void _saveResident() async {
    _firestore.collection('RC').doc(_emailController.text).set({
      'name': _nameController.text,
      'email': _emailController.text,
      'number': _phoneController.text,
      'block': _blockController.text,
    }).then((value) {
      FirebaseAuth auth = FirebaseAuth.instance;
      auth.createUserWithEmailAndPassword(
          email: _emailController.text, password: _phoneController.text);
      print('Data added successfully!');
    });
  }
}
